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
            fetchFunction: (params) =>
                restClient.get(Endpoint.chat, queryParams: params)),
        groups = GroupsStore(
          fetchFunction: (params) =>
              restClient.get(Endpoint().groups, queryParams: params),
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
}
