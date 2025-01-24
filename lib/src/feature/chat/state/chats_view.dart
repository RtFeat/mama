import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

import 'chats.dart';
import 'groups.dart';

part 'chats_view.g.dart';

class ChatsViewStore extends _ChatsViewStore with _$ChatsViewStore {
  ChatsViewStore({
    required super.restClient,
  });
}

abstract class _ChatsViewStore with Store {
  final ChatsStore chats;

  final GroupsStore groups;

  _ChatsViewStore({
    required RestClient restClient,
  })  : chats = ChatsStore(
            restClient: restClient,
            fetchFunction: (params, path) =>
                restClient.get(path, queryParams: params)),
        groups = GroupsStore(
          restClient: restClient,
          fetchFunction: (params, path) =>
              restClient.get(path, queryParams: params),
        );

  @observable
  ObservableFuture? fetchFuture;

  @action
  void setFetchFuture(ObservableFuture? value) => fetchFuture = value;

  Future loadAllChats() async {
    await chats.loadPage(queryParams: {});
  }

  Future loadAllGroups(
    String? childId,
  ) async {
    await groups.loadPage(queryParams: {
      if (childId != null) 'child_id': childId,
    });
  }

  @action
  void deleteChat(String id, String chatType) {
    if (chatType == 'group') {
      groups.deleteGroup(id);
    } else {
      chats.deleteChat(id);
    }
  }
}
