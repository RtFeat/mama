import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:televerse/televerse.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocket {
  final MessagesStore store;
  final ChatsViewStore chatsViewStore;
  final Fresh tokenStorage;
  final Bot bot;
  final ApiClient apiClient;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;
  String? _accessToken;

  bool _isConnected = false;
  bool _isClosed = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts;
  final Duration _pingInterval;

  Timer? _pingTimer;
  final ID _chatId = ChatID(958930260);

  final _messageQueue = Queue<Map<String, dynamic>>();
  final _pendingCompleters = Queue<Completer<void>>();
  bool _isProcessingQueue = false;

  ChatSocket({
    required this.bot,
    required this.store,
    required this.tokenStorage,
    required this.chatsViewStore,
    required this.apiClient,
    int maxReconnectAttempts = 5,
    Duration pingInterval = const Duration(seconds: 30),
  })  : _maxReconnectAttempts = maxReconnectAttempts,
        _pingInterval = pingInterval;

  Future<void> initialize({bool forceReconnect = false}) async {
    if (!forceReconnect) {
      if (_isClosed) return;
      if (_isConnected) return;
    }
    await _disconnect();

    try {
      _accessToken = await _getToken();
      if (_accessToken == null) throw Exception('No access token');

      _channel = WebSocketChannel.connect(
        Uri.parse('wss://api.mama-api.ru/api/v1/chat/ws'),
      );

      _setupListeners();
      await _sendHandshake();
      _isConnected = true;
      _reconnectAttempts = 0;
      _startPing(); // 💥 Запуск heartbeat
      _processQueue(); // 🔥 Старт очереди
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> sendMessage({
    required String text,
    required String chatId,
    String replyId = '',
    List<MessageFile>? files,
  }) async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);

    await initialize();

    _messageQueue.add({
      'event': 'message',
      'type_chat': store.chatType,
      'data': {
        'message': text,
        'chat_id': chatId,
        'reply': replyId,
        if (files != null) 'upload_data': files,
      }
    });

    _processQueue();
    return completer.future;
  }

  Future<void> deleteMessage(String messageId) async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);
    await initialize();

    _messageQueue.add({
      'event': 'delete_message',
      'type_chat': store.chatType,
      'data': {
        'message_id': messageId,
      }
    });

    _processQueue();
    return completer.future;
  }

  Future<void> deleteChat(String chatId) async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);
    await initialize();

    _messageQueue.add({
      'event': 'delete_chat',
      'data': {
        'chat_id': chatId,
      }
    });

    _processQueue();
    return completer.future;
  }

  Future<void> pinMessage(String messageId, bool pin) async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);
    await initialize();

    final Map<String, dynamic> data = {
      'event': pin ? 'pin_message' : 'unpin_message',
      'type_chat': store.chatType,
      'data': {
        'message_id': messageId,
        'chat_id': store.chatId,
      }
    };
    _messageQueue.add(data);

    _processQueue();
    return completer.future;
  }

  Future<void> markAsRead() async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);

    _messageQueue.add({
      'event': 'read_message',
      'type_chat': store.chatType,
      'data': {
        'chat_id': store.chatId,
      }
    });

    _processQueue();
    return completer.future;
  }

  Future<void> close() async {
    _isClosed = true;
    _stopPing();
    await _disconnect();
    for (var c in _pendingCompleters) {
      c.completeError(Exception('Socket closed'));
    }
    _pendingCompleters.clear();
  }

  void _startPing() {
    _stopPing();
    if (_channel == null) return;
    _pingTimer = Timer.periodic(_pingInterval, (timer) {
      try {
        final pingMsg = json.encode({'event': 'ping'});
        _channel?.sink.add(pingMsg);
        logger.info('➡️ ПИНГ');
      } catch (e) {
        logger.error('Ошибка при отправке ping: $e');
        _reconnect();
      }
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Future<void> _processQueue() async {
    if (_isProcessingQueue || !_isConnected || _messageQueue.isEmpty) return;
    _isProcessingQueue = true;
    try {
      // TOKEN: получать только если null или истёк
      _accessToken ??= await _getToken();
      if (_accessToken == null) throw Exception('Invalid token');
      if (_isTokenExpiredByString(_accessToken!)) {
        _accessToken = await _refreshToken();
        if (_accessToken == null)
          throw Exception('Invalid token after refresh');
      }
      while (_messageQueue.isNotEmpty && _isConnected && !_isClosed) {
        final message = _messageQueue.first;
        try {
          // Добавляем токен в сообщение
          (message['data'] as Map)['access_token'] = 'Bearer $_accessToken';

          // Отправляем
          _channel?.sink.add(json.encode(message));
          logger.info('➡️ ОТПРАВЛЕНО НА СЕРВЕР: ${json.encode(message)}');
          _messageQueue.removeFirst();

          if (_pendingCompleters.isNotEmpty) {
            _pendingCompleters.removeFirst().complete();
          }

          // Уменьшаем задержку между сообщениями
          await Future.delayed(const Duration(milliseconds: 20));
        } catch (e) {
          logger.error('Failed to send message: $e');
          if (_pendingCompleters.isNotEmpty) {
            _pendingCompleters.removeFirst().completeError(e);
          }
          // Добавляем повторные попытки отправки
          int retryCount = 0;
          while (retryCount < 3 && !_isClosed) {
            try {
              await _reconnect();
              await Future.delayed(const Duration(seconds: 1));
              retryCount++;
            } catch (e) {
              logger.error('Retry attempt $retryCount failed: $e');
            }
          }
          break;
        }
      }
    } catch (e) {
      logger.error('Queue processing crashed: $e');
    } finally {
      _isProcessingQueue = false;
    }
  }

  Future<void> _disconnect() async {
    await _socketSub?.cancel();
    await _channel?.sink.close();
    _isConnected = false;
    _stopPing();
  }

  Future<String?> _getToken() async {
    final token = await tokenStorage.token;
    if (token != null && !_isTokenExpired(token)) {
      return token.accessToken;
    }
    return await _refreshToken();
  }

  bool _isTokenExpired(OAuth2Token token) {
    final expiryDate = JwtDecoder.getExpirationDate(token.accessToken);
    return expiryDate.isBefore(DateTime.now());
  }

  // Для проверки быстро по raw-строке токена
  bool _isTokenExpiredByString(String accessToken) {
    final expiryDate = JwtDecoder.getExpirationDate(accessToken);
    return expiryDate.isBefore(DateTime.now());
  }

  Future<String?> _refreshToken() async {
    try {
      final currentToken = await tokenStorage.token;
      if (currentToken == null) return null;

      final dio = Dio();
      final response = await dio.get(
        '${const AppConfig().apiUrl}${Endpoint().accessToken}',
        options: Options(
            headers: {'Refresh-Token': 'Bearer ${currentToken.refreshToken}'}),
      );

      final newToken = OAuth2Token(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
      );

      await tokenStorage.setToken(newToken);
      return newToken.accessToken;
    } catch (e) {
      logger.error('Token refresh failed: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        await close();
        bot.api.sendMessage(_chatId, 'Session expired. Please login again.');
      }
      return null;
    }
  }

  void _setupListeners() {
    _socketSub = _channel?.stream.listen(
      _handleMessage,
      onError: (error) {
        logger.error('Socket error: $error');
        bot.api.sendMessage(_chatId, 'Socket error: $error');
        Future.delayed(const Duration(seconds: 1), () {
          _reconnect();
        });
      },
      onDone: () {
        logger.error('Socket closed');
        bot.api.sendMessage(_chatId, 'Socket closed');
        if (!_isClosed) {
          Future.delayed(const Duration(seconds: 1), () {
            _reconnect();
          });
        }
      },
      cancelOnError: true,
    );

    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isConnected && !_isClosed) {
        logger.info('Checking connection status...');
        initialize(forceReconnect: true);
      }
    });
  }

  Future<void> _sendHandshake() async {
    logger.info('Sending handshake with token: $_accessToken');
    if (_channel == null || _accessToken == null) return;

    final messages = [
      {
        'event': 'join',
        'type_chat': 'solo',
        'data': {'access_token': 'Bearer $_accessToken'},
      },
      {
        'event': 'join',
        'type_chat': 'group',
        'data': {'access_token': 'Bearer $_accessToken'},
      }
    ];

    for (final msg in messages) {
      try {
        _channel?.sink.add(json.encode(msg));
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        logger.error('Ошибка отправки сообщения: $e');
        bot.api.sendMessage(_chatId, 'Socket error: $e');
      }
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data);

      final response = SocketResponse.fromJson(jsonData);

      logger.info('⬅️ ПОЛУЧЕНО ОТ СЕРВЕРА: $data');

      if (response.error == 'invalid_token') {
        _refreshToken().then((_) => _reconnect());
        return;
      }

      logger.info('Event: ${response.event}');

      switch (response.event) {
        case 'message':
          _handleNewMessage(response);
          break;
        case 'delete_message':
          _handleDeletedMessage(response);
          break;
        case 'pong': // Для отклика на ping
          logger.info('PONG получен');
          break;
        default:
          logger.error('Unhandled event: ${response.event}');
      }
    } catch (e) {
      logger.error('Error handling message: $e');
      bot.api.sendMessage(_chatId, 'Error handling message: $e');
    }
  }

  void _handleNewMessage(SocketResponse response) {
    final message = response.data?.message;

    if (message == null) return;

    // Проверяем дубликаты по id и содержимому
    if (store.messages.any((m) =>
        m.id == message.id ||
        (m.text == message.text &&
            m.senderId == message.senderId &&
            (m.createdAt != null &&
                message.createdAt != null &&
                m.createdAt!.difference(message.createdAt!).inSeconds.abs() <
                    5)))) {
      logger.info('Duplicate message detected: ${message.id}');
      return;
    }

    try {
      store.addMessage(message);
      chatsViewStore.selectedChat?.setLastMessage(message);
    } catch (e) {
      logger.error('Error adding message to store: $e');
      // Пробуем переподключиться при ошибке добавления сообщения
      _reconnect();
    }
  }

  Future<void> markMessagesAsRead() async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);

    _messageQueue.add({
      'event': 'read_message',
      'type_chat': store.chatType,
      'data': {'chat_id': store.chatId}
    });

    _processQueue();
    return completer.future;
  }

  void _handleDeletedMessage(SocketResponse response) {
    final messageId = response.data?.messageId;
    if (messageId != null) {
      store.removeMessage(messageId);
      if (chatsViewStore.selectedChat != null) {
        if (store.messages.isNotEmpty) {
          chatsViewStore.selectedChat?.setLastMessage(store.messages.first);
        } else {
          chatsViewStore.selectedChat?.setLastMessage(null);
        }
      }
    }
  }

  Future<void> _reconnect() async {
    if (_isClosed || _reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectAttempts++;
    final delay =
        Duration(seconds: min(_reconnectAttempts, 5) + Random().nextInt(2));
    logger.info('Reconnecting in ${delay.inSeconds}s...');
    await Future.delayed(delay);

    try {
      _messageQueue.clear();
      for (var c in _pendingCompleters) {
        c.completeError(Exception('Connection lost'));
      }
      _pendingCompleters.clear();

      await initialize(forceReconnect: true);
    } catch (e) {
      logger.error('Reconnect failed: $e');
      bot.api.sendMessage(_chatId, 'Reconnect failed: $e');
      if (!_isClosed) _reconnect();
    }
  }

  void _handleError(dynamic error) {
    logger.error('Socket error: $error');
    bot.api.sendMessage(_chatId, 'Socket error: $error');
    if (!_isClosed) _reconnect();
  }
}
