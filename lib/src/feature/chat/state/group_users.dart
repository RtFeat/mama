import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

part 'group_users.g.dart';

class GroupUsersStore extends _GroupUsersStore with _$GroupUsersStore {
  GroupUsersStore({
    required super.apiClient,
    required super.chatId,
    required super.faker,
  });
}

abstract class _GroupUsersStore extends PaginatedListStore with Store {
  final String chatId;

  _GroupUsersStore({
    required super.apiClient,
    required this.chatId,
    required super.faker,
  }) : super(
            pageSize: 100,
            testDataGenerator: () {
              return AccountModel(
                id: faker.datatype.uuid(),
                firstName: faker.name.firstName(),
                secondName: faker.name.lastName(),
                avatarUrl: faker.image.image(),
                gender: Gender.values[
                    faker.datatype.number(max: Gender.values.length - 1)],
                phone: faker.phoneNumber.phoneNumber(),
              );
            },
            basePath: Endpoint().groupUsers,
            fetchFunction: (params, path) =>
                apiClient.get('$path/$chatId', queryParams: params),
            transformer: (raw) {
              return {
                'main': (raw['users'] as List?)
                        ?.map((e) => AccountModel.fromJson(e))
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

  @computed
  ObservableList<AccountModel> get filteredUsers => ObservableList.of(
      filteredList.where((e) => e.role == Role.user) as List<AccountModel>);

  @observable
  String? query;

  @action
  void setQuery(String value) {
    logger.info('query $value', runtimeType: runtimeType);
    query = value;

    filters.clear();
    filters.add(SkitFilter<AccountModel>(
      field: 'query',
      operator: FilterOperator.contains,
      value: value,
      localPredicate: (item) {
        if (value.isEmpty) return true;
        final contains = item.name.toLowerCase().contains(value.toLowerCase());
        return contains;
      },
    ));
  }

  // @action
  // @override
  // void setFilters(Map<String, dynamic> filters) {
  //   super.setFilters(filters as Map<String, FilterFunction<dynamic>>);
  //   filteredUsers = applyFilters(listData) as ObservableList<AccountModel>;
  // }
  // @override
  // void setFilters(Map<String, FilterFunction<AccountModel>> filters) {
  //   super.setFilters(filters);
  //   filteredUsers = applyFilters(listData);
  // }

  FormGroup formGroup = FormGroup({
    'search': FormControl<String>(),
  });
}
