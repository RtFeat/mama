import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'group_specialists.g.dart';

class GroupSpecialistsStore extends _GroupSpecialistsStore
    with _$GroupSpecialistsStore {
  GroupSpecialistsStore({
    required super.apiClient,
    required super.chatId,
    required super.faker,
  });
}

abstract class _GroupSpecialistsStore extends PaginatedListStore<AccountMe>
    with Store {
  final String chatId;

  _GroupSpecialistsStore({
    required super.apiClient,
    required this.chatId,
    required super.faker,
  }) : super(
            pageSize: 100,
            testDataGenerator: () {
              return AccountMe(
                account: AccountModel.mock(faker),
                doctor: Doctor(),
                onlineSchool: OnlineSchool(),
              );
            },
            basePath: Endpoint().groupSpecialists,
            fetchFunction: (params, path) =>
                apiClient.get('$path/$chatId', queryParams: params),
            transformer: (raw) {
              return {
                'main': (raw['specialists'] as List?)
                        ?.map((e) => AccountMe.fromJson(e))
                        .toList() ??
                    [],
              };

              // final List<AccountModel>? data = (raw['users'] as List?)
              //     ?.map((e) => AccountModel.fromJson(e))
              //     .toList();

              // final List<AccountModel>? specialists =
              //     (raw['specialists'] as List?)
              //         ?.map((e) => AccountModel.fromJson(e))
              //         .toList();

              // return data ?? [];
            });
}
