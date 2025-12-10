import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'profile_info.g.dart';

class ProfileInfoViewStore extends _ProfileInfoViewStore
    with _$ProfileInfoViewStore {
  ProfileInfoViewStore({
    required super.apiClient,
    required super.chatsViewStore,
    required super.messagesStore,
    required super.socket,
  });
}

abstract class _ProfileInfoViewStore with Store {
  final ApiClient apiClient;
  final ChatsViewStore chatsViewStore;
  final MessagesStore messagesStore;
  final ChatSocket socket;

  _ProfileInfoViewStore({
    required this.apiClient,
    required this.chatsViewStore,
    required this.messagesStore,
    required this.socket,
  });

  @action
  Future createChat(String userId) async {
    apiClient.post(Endpoint().createChat, body: {
      'account_id': userId,
    }).then((v) {
      final Map<String, dynamic>? map = v != null && v.keys.contains('chat')
          ? v['chat'] as Map<String, dynamic>?
          : null;

      if (map != null) {
        final SingleChatItem chat = SingleChatItem.fromJson(map);

        chatsViewStore.chats.listData.insert(0, chat);

        messagesStore.setChatId(chat.id);
        chatsViewStore.setSelectedChat(chat);

        socket.initialize(forceReconnect: true);

        router.goNamed(AppViews.chatView, extra: {'item': chat});
      }
    });
  }

  @action
  Future deleteChat() async {
    final chatId = messagesStore.chatId;
    if (chatId != null) {
      socket.deleteChat(chatId);
      chatsViewStore.deleteChat(chatId);
      router.goNamed(AppViews.homeScreen);
    }
  }
}
