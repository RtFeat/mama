import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocket {
  final MessagesStore store;
  final ChatsViewStore chatsViewStore;
  final Fresh tokenStorage;

  ChatSocket(
      {required this.store,
      required this.tokenStorage,
      required this.chatsViewStore});

  WebSocketChannel? channel;
  StreamSubscription? _socketSubscription;
  String? accessToken;

  bool isConnected = false;
  bool isClosed = false;

  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  void close() {
    isClosed = true;
    channel?.sink.close();
  }

  Future<void> initializeSocket() async {
    await _socketSubscription?.cancel();
    accessToken = await tokenStorage.token.then((token) => token?.accessToken);

    channel = WebSocketChannel.connect(
      Uri.parse('wss://api.mama-api.ru/api/v1/chat/ws'),
    );

    _socketSubscription = channel?.stream.listen(
      (data) {
        isConnected = true;
        logger.info('onData: $data', runtimeType: runtimeType);
        final dataInfo = SocketResponse.fromJson(jsonDecode(data));

        if (dataInfo.error != null && dataInfo.error == 'invalid token') {
          refreshToken().then((_) => reconnect());
          return;
        }

        if (dataInfo.event == 'message') {
          handleMessage(dataInfo);
        } else if (dataInfo.event == 'delete_message') {
          handleDeleteMessage(dataInfo);
        }
      },
      onError: (error) {
        isConnected = false;
        logger.error('onError: $error');
        reconnect();
      },
      onDone: () {
        isConnected = false;
        if (!isClosed) reconnect();
      },
    );

    final data = json.encode({
      'event': 'join',
      'type_chat': 'solo',
      'data': {
        'access_token': 'Bearer $accessToken',
      },
    });
    channel?.sink.add(data);

    final data2 = json.encode({
      'event': 'join',
      'type_chat': 'group',
      'data': {
        'access_token': 'Bearer $accessToken',
      },
    });
    channel?.sink.add(data2);
  }

  Future<OAuth2Token?> refreshToken() async {
    try {
      final currentToken = await tokenStorage.token;
      if (currentToken == null) return null;

      final dio = Dio(BaseOptions(
        baseUrl: const AppConfig().apiUrl,
        followRedirects: true,
      ));

      final response = await dio.get(
        '${const AppConfig().apiUrl}${Endpoint().accessToken}',
        options: Options(
          headers: {'Refresh-Token': 'Bearer ${currentToken.refreshToken}'},
          followRedirects: true,
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 401) {
        await tokenStorage.clearToken();
        return null;
      }

      final newToken = OAuth2Token(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
      );

      await tokenStorage.setToken(newToken);
      return newToken;
    } catch (e) {
      logger.error('Error refreshing token: $e');
      return null;
    }
  }

  Future<void> reconnect() async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      logger.error('Max reconnect attempts reached');
      return;
    }

    _reconnectAttempts++;
    logger.info('Attempting to reconnect (attempt $_reconnectAttempts)...');

    try {
      await initializeSocket();
      _reconnectAttempts = 0;
      logger.info('Reconnected successfully!');
    } catch (e) {
      logger.error('Reconnection failed: $e');
      await Future.delayed(Duration(seconds: 5 * _reconnectAttempts));
      if (!isClosed) reconnect();
    }
  }

  Future<void> ensureConnection() async {
    if (!isConnected) {
      logger.info('Connection lost. Reconnecting...', runtimeType: runtimeType);
      await reconnect();
    }
  }

  Future<void> sendMessage({
    required String messageText,
    required String chatId,
    String replyMessageId = '',
    List<MessageFile>? files,
  }) async {
    await ensureConnection();
    if (channel == null || channel?.sink == null) {
      logger.error('WebSocket channel is not initialized or sink is null');
      return;
    }

    if (accessToken == null) {
      logger.error('Access token is null, cannot send message.');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final data = jsonEncode({
      'event': 'message',
      'type_chat': store.chatType,
      'data': {
        'access_token': 'Bearer $accessToken',
        'message': messageText,
        'chat_id': chatId,
        'reply': replyMessageId,
        if (files != null) 'upload_data': files
      }
    });

    try {
      logger.info('Sending message: $messageText');
      channel?.sink.add(data);
    } catch (e) {
      logger.error('Error sending message: $e');
    }
  }

  deleteMessage({
    required String messageId,
  }) async {
    await ensureConnection();
    var data = jsonEncode({
      'event': 'delete_message',
      'type_chat': store.chatType,
      'data': {
        'access_token': 'Bearer $accessToken',
        'message_id': messageId,
      }
    });
    channel?.sink.add(data);
    store.removeMessage(messageId);
  }

  pinMessage({
    required String messageId,
    required bool isAttached,
  }) async {
    await ensureConnection();
    var data = jsonEncode({
      'event': isAttached ? 'unpin_message' : 'pin_message',
      'type_chat': store.chatType,
      'data': {
        'access_token': 'Bearer $accessToken',
        'message_id': messageId,
        'chat_id': store.chatId,
      }
    });
    channel?.sink.add(data);
  }

  iAmActive() async {
    await ensureConnection();
    var data = jsonEncode({
      'event': 'i_am_active',
      'data': {
        'access_token': 'Bearer $accessToken',
      }
    });
    channel?.sink.add(data);
  }

  deleteChat() async {
    await ensureConnection();
    var data = jsonEncode({
      'event': 'delete_chat',
      'type_chat': store.chatType,
      'data': {
        'access_token': 'Bearer $accessToken',
        'chat_id': store.chatId,
      }
    });
    channel?.sink.add(data);
    chatsViewStore.deleteChat(store.chatId!, store.chatType!);
  }

  Future<void> readMessage() async {
    await ensureConnection();
    var data = jsonEncode({
      'event': 'read_message',
      'type_chat': store.chatType,
      'data': {
        'access_token': 'Bearer $accessToken',
        'chat_id': store.chatId,
      }
    });
    channel?.sink.add(data);
  }

  dynamic handleMessage(SocketResponse data) async {
    final MessageItem message = MessageItem(
      id: data.data?.message?.id ?? '',
      chatId: data.data?.message?.chatId ?? '',
      createdAt: data.data?.message?.createdAt,
      text: data.data?.message?.text ?? '',
      files: data.data?.message?.files,
      readAt: data.data?.message?.readAt,
      senderId: data.data?.message?.senderId ?? '',
      reply: MessageItem(
        id: data.data?.message?.reply?.id ?? '',
        chatId: data.data?.message?.reply?.chatId ?? '',
        createdAt: data.data?.message?.reply?.createdAt,
        text: data.data?.message?.reply?.text ?? '',
        files: data.data?.message?.reply?.files,
        readAt: data.data?.message?.reply?.readAt,
        senderId: data.data?.message?.reply?.senderId ?? '',
      ),
    );
    logger.info('Received message with ID: ${data.data?.message?.id}');
    if (store.messages.any((m) => m.id == message.id)) {
      logger.warning('Duplicate message detected: ${message.id}');
      return;
    }

    store.addMessage(data.data?.message ?? message);
  }

  dynamic handleDeleteMessage(SocketResponse data) async {
    // final chatBloc = GetIt.instance.get<ChatBloc>();

    // chatBloc.add(
    //   ChatEvent.socketDeleteMessage(
    //     data.data?.chatId ?? '',
    //     data.typeChat ?? '',
    //   ),
    // );

    store.removeMessage(data.data?.messageId ?? '');
  }
}
