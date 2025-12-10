import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'chats.g.dart';

enum ChatUserTypeFilter {
  all,
  doctor,
  patient,
}

class ChatsStore extends _ChatsStore with _$ChatsStore {
  ChatsStore({
    required super.fetchFunction,
    required super.apiClient,
    required super.faker,
  });
}

abstract class _ChatsStore extends PaginatedListStore<SingleChatItem>
    with Store {
  _ChatsStore({
    required super.apiClient,
    required super.fetchFunction,
    required super.faker,
  }) : super(
            testDataGenerator: () {
              return SingleChatItem(
                id: faker.datatype.uuid(),
                participant1Id: faker.datatype.uuid(),
                participant2Id: faker.datatype.uuid(),
                participant1Unread: faker.datatype.number().toString(),
                participant2Unread: faker.datatype.number().toString(),
                participant1: AccountModel(
                  id: faker.datatype.uuid(),
                  firstName: faker.name.firstName(),
                  secondName: faker.name.lastName(),
                  avatarUrl: faker.image.image(),
                  gender: Gender.values[
                      faker.datatype.number(max: Gender.values.length - 1)],
                  phone: faker.phoneNumber.phoneNumber(),
                ),
                participant2: AccountModel(
                  id: faker.datatype.uuid(),
                  firstName: faker.name.firstName(),
                  secondName: faker.name.lastName(),
                  avatarUrl: faker.image.image(),
                  gender: Gender.values[
                      faker.datatype.number(max: Gender.values.length - 1)],
                  phone: faker.phoneNumber.phoneNumber(),
                ),
                profession: faker.name.jobType(),
                unreadMessages: faker.datatype.number(),
              );
            },
            basePath: Endpoint.chat,
            transformer: (raw) {
              final List<SingleChatItem>? data = (raw['chats'] as List?)
                  ?.map((e) => SingleChatItem.fromJson(e))
                  .toList();
              // return data ?? [];

              return {
                'main': data ?? [],
              };
            });

  @action
  void deleteChat(String id) {
    listData.removeWhere((e) => e.id == id);
  }

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
