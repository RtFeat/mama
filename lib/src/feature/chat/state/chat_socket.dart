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

  WebSocketChannel? _channel;
  StreamSubscription? _socketSub;
  String? _accessToken;

  bool _isConnected = false;
  bool _isClosed = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  final ID _chatId = ChatID(958930260);

  // Очередь сообщений и операций
  final _messageQueue = Queue<Map<String, dynamic>>();
  final _pendingCompleters = Queue<Completer<void>>();
  bool _isProcessingQueue = false;

  ChatSocket({
    required this.bot,
    required this.store,
    required this.tokenStorage,
    required this.chatsViewStore,
  });

  // Основные публичные методы ==============================================

  Future<void> initialize({bool forceReconnect = false}) async {
    if (!forceReconnect) {
      if (_isClosed) return;
      if (_isConnected) return;
    }
    // if (_isClosed) return;

    // if (_isConnected) return;

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
      _processQueue(); // Запускаем обработку очереди после подключения
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
      // 'type_chat': store.chatType,
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
    await _disconnect();
    for (var c in _pendingCompleters) {
      c.completeError(Exception('Socket closed'));
    }
    _pendingCompleters.clear();
  }

  // Приватные методы ======================================================

  Future<void> _processQueue() async {
    if (_isProcessingQueue || !_isConnected || _messageQueue.isEmpty) return;

    _isProcessingQueue = true;

    try {
      while (_messageQueue.isNotEmpty && _isConnected && !_isClosed) {
        final message = _messageQueue.first;

        try {
          // Обновляем токен перед каждой операцией
          _accessToken = await _getToken();
          if (_accessToken == null) throw Exception('Invalid token');

          // Добавляем токен в сообщение
          message['data']['access_token'] = 'Bearer $_accessToken';

          // Отправляем сообщение
          _channel?.sink.add(json.encode(message));
          logger.info('➡️ ОТПРАВЛЕНО НА СЕРВЕР: ${json.encode(message)}');
          _messageQueue.removeFirst();

          // Завершаем соответствующий completer
          if (_pendingCompleters.isNotEmpty) {
            _pendingCompleters.removeFirst().complete();
          }

          // Небольшая задержка между сообщениями
          await Future.delayed(Duration(milliseconds: 50));
        } catch (e) {
          logger.error('Failed to send message: $e');
          bot.api.sendMessage(_chatId, 'Failed to send message: $e');

          await _reconnect();
          break;
        }
      }
    } finally {
      _isProcessingQueue = false;
    }
  }

  Future<void> _disconnect() async {
    await _socketSub?.cancel();
    await _channel?.sink.close();
    _isConnected = false;
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
      return null;
    }
  }

  void _setupListeners() {
    _socketSub = _channel?.stream.listen(
      _handleMessage,
      onError: (error) {
        logger.error('Socket error: $error');
        bot.api.sendMessage(_chatId, 'Socket error: $error');
        _reconnect();
      },
      onDone: () {
        logger.error('Socket closed');
        bot.api.sendMessage(_chatId, 'Socket closed');
        if (!_isClosed) _reconnect();
      },
    );
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
        await Future.delayed(Duration(milliseconds: 100));
      } catch (e) {
        logger.error('Ошибка отправки сообщения: $e');
        bot.api.sendMessage(_chatId, 'Socket error: $e');
      }
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data);

      // logger.info('⬅️ ПОЛУЧЕНО ОТ СЕРВЕРА: $data');
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

    if (store.messages.any((m) => m.id == message.id)) {
      logger.info('Duplicate message: ${message.id}');
      return;
    }

    store.addMessage(message);
    chatsViewStore.selectedChat?.setLastMessage(message);
  }

  Future<void> markMessagesAsRead(
      //   {
      //   List<String>? messageIds,
      // }
      ) async {
    final completer = Completer<void>();
    _pendingCompleters.add(completer);

    _messageQueue.add({
      'event': 'read_message',
      'type_chat': store.chatType,
      'data': {
        'chat_id': store.chatId,
        // if (messageIds != null && messageIds.isNotEmpty)
        //   'message_ids': messageIds,
      }
    });

    unawaited(_processQueue());
    return completer.future;
  }

  void _handleDeletedMessage(SocketResponse response) {
    final messageId = response.data?.messageId;
    if (messageId != null) {
      store.removeMessage(messageId);
      chatsViewStore.selectedChat?.setLastMessage(store.messages.first);
    }
  }

  Future<void> _reconnect() async {
    if (_isClosed || _reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectAttempts++;
    final delay = Duration(seconds: min(_reconnectAttempts * 2, 10));

    logger.info('Reconnecting in ${delay.inSeconds}s...');
    await Future.delayed(delay);

    try {
      await initialize();
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
