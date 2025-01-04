import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'chats.g.dart';

enum ChatUserTypeFilter {
  all,
  doctor,
  patient,
}

class ChatsStore extends _ChatsStore with _$ChatsStore {
  ChatsStore({required super.fetchFunction});
}

abstract class _ChatsStore extends PaginatedListStore<SingleChatItem>
    with Store {
  _ChatsStore({required super.fetchFunction})
      : super(transformer: (raw) {
          final List<SingleChatItem>? data = (raw['chats'] as List?)
              ?.map((e) => SingleChatItem.fromJson(e))
              .toList();
          return data ?? [];
        });

  @observable
  ChatUserTypeFilter chatUserTypeFilter = ChatUserTypeFilter.all;

  @action
  void setChatUserTypeFilter(ChatUserTypeFilter value) {
    chatUserTypeFilter = value;
  }

  @computed
  ObservableList<SingleChatItem> get filteredChats => ObservableList.of(
        listData.where((item) {
          switch (chatUserTypeFilter) {
            case ChatUserTypeFilter.doctor:
              final doctor = item.participant2?.role == Role.doctor;

              return doctor;

            default:
              return true;
          }
        }).toList(),
      );
}


// class ChatsStore extends PaginatedListStore<SingleChatItem> {
//   ChatsStore({required super.fetchFunction})
//       : super(transformer: (raw) {
//           final List<SingleChatItem>? data = (raw['chats'] as List?)
//               ?.map((e) => SingleChatItem.fromJson(e))
//               .toList();
//           return data ?? [];
//         });
// }
