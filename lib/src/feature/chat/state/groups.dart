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
                participant: AccountModel(
                  id: faker.datatype.uuid(),
                  firstName: faker.name.firstName(),
                  secondName: faker.name.lastName(),
                  avatarUrl: faker.image.image(),
                  gender: Gender.values[
                      faker.datatype.number(max: Gender.values.length - 1)],
                  phone: faker.phoneNumber.phoneNumber(),
                ),
              );
            },
            basePath: Endpoint().groups,
            transformer: (raw) {
              // final data =  ChatsData.fromJson(raw);

              final List<GroupItem>? data = (raw['chats'] as List?)
                  ?.map((e) => GroupItem.fromJson(e))
                  .toList();
              return data ?? [];
            });

  @action
  void deleteGroup(String id) {
    listData.removeWhere((e) => e.id == id);
  }
}
