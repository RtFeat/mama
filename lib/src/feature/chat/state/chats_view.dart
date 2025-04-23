import 'package:faker_dart/faker_dart.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

import 'chats.dart';
import 'groups.dart';

part 'chats_view.g.dart';

class ChatsViewStore extends _ChatsViewStore with _$ChatsViewStore {
  ChatsViewStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _ChatsViewStore with Store {
  final ChatsStore chats;

  final GroupsStore groups;

  _ChatsViewStore({
    required ApiClient apiClient,
    required Faker faker,
  })  : chats = ChatsStore(
            faker: faker,
            apiClient: apiClient,
            fetchFunction: (params, path) =>
                apiClient.get(path, queryParams: params)),
        groups = GroupsStore(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
        );

  @observable
  ObservableFuture? fetchFuture;

  @action
  void setFetchFuture(ObservableFuture? value) => fetchFuture = value;

  @observable
  ChatItem? selectedChat;

  @action
  void setSelectedChat(ChatItem? value) => selectedChat = value;

  Future loadAllChats() async {
    await chats.loadPage();
  }

  Future loadAllGroups(
    String? childId,
  ) async {
    await groups.loadPage(
      newFilters: [
        if (childId != null)
          SkitFilter(
              field: 'child_id',
              operator: FilterOperator.equals,
              value: childId),
      ],
    );
  }

  @action
  void deleteChat(String id, {String chatType = 'chat'}) {
    if (chatType == 'group') {
      groups.deleteGroup(id);
    } else {
      chats.deleteChat(id);
    }
  }
}
