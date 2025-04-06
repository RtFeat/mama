import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'groups.g.dart';

class GroupsStore extends _GroupsStore with _$GroupsStore {
  GroupsStore({
    required super.fetchFunction,
    required super.faker,
    required super.apiClient,
  });
}

abstract class _GroupsStore extends PaginatedListStore<GroupItem> with Store {
  _GroupsStore({
    required super.fetchFunction,
    required super.apiClient,
    required super.faker,
  }) : super(
            testDataGenerator: () {
              return GroupItem(
                groupChatId: faker.datatype.uuid(),
                participantId: faker.datatype.uuid(),
                participant: AccountModel.mock(faker),
                groupInfo: GroupChatInfo(
                  id: faker.datatype.uuid(),
                  name: faker.lorem.word(),
                  avatarUrl: faker.image.image(),
                ),
              );
            },
            basePath: Endpoint().groups,
            transformer: (raw) {
              // final data =  ChatsData.fromJson(raw);

              return {
                'main': (raw['chats'] as List?)
                        ?.map((e) => GroupItem.fromJson(e))
                        .toList() ??
                    [],
              };

              // final List<GroupItem>? data = (raw['chats'] as List?)
              //     ?.map((e) => GroupItem.fromJson(e))
              //     .toList();
              // return data ?? [];
            });

  @action
  void deleteGroup(String id) {
    listData.removeWhere((e) => e.id == id);
  }
}
