import 'package:mama/src/data.dart';

class ChatSocketFactory {
  final Dependencies dependencies;
  final MessagesStore messagesStore;
  final ChatsViewStore chatsViewStore;
  final AuthStore store;
  final UserStore userStore;

  ChatSocket? _currentSocket;

  ChatSocketFactory({
    required this.dependencies,
    required this.messagesStore,
    required this.chatsViewStore,
    required this.store,
    required this.userStore,
  });

  ChatSocket get socket {
    if (_currentSocket == null || !store.isAuthorized) {
      if (_currentSocket != null) {
        _currentSocket!.close();
      }

      _currentSocket = ChatSocket(
        userStore: userStore,
        apiClient: dependencies.apiClient,
        bot: dependencies.bot,
        chatsViewStore: chatsViewStore,
        store: messagesStore,
        tokenStorage: dependencies.tokenStorage,
      );
    }

    return _currentSocket!;
  }

  void reset() {
    if (_currentSocket != null) {
      _currentSocket!.close();
      _currentSocket = null;
    }
  }

  void dispose() {
    reset();
  }
}
