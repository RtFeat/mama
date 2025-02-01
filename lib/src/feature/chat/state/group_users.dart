import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skit/skit.dart';

part 'group_users.g.dart';

class GroupUsersStore extends _GroupUsersStore with _$GroupUsersStore {
  GroupUsersStore({
    required super.apiClient,
    required super.chatId,
  });
}

abstract class _GroupUsersStore extends PaginatedListStore<AccountModel>
    with Store, FilterableDataMixin<AccountModel> {
  final String chatId;

  _GroupUsersStore({
    required super.apiClient,
    required this.chatId,
  }) : super(
            basePath: Endpoint().groupUsers,
            fetchFunction: (params, path) =>
                apiClient.get('$path/$chatId', queryParams: params),
            transformer: (raw) {
              final List<AccountModel>? data = (raw['account'] as List?)
                  ?.map((e) => AccountModel.fromJson(e))
                  .toList();

              return data ?? [];
            });

  @computed
  ObservableList<AccountModel> get doctors =>
      ObservableList.of(listData.where((e) => e.role != Role.user));

  @computed
  ObservableList<AccountModel> get users =>
      ObservableList.of(listData.where((e) => e.role == Role.user));

  @observable
  String? query;

  @action
  void setQuery(String value) {
    logger.info('query $value', runtimeType: runtimeType);
    query = value;
  }

  @action
  @override
  void setFilters(Map<String, FilterFunction<AccountModel>> filters) {
    super.setFilters(filters);
    filteredUsers = applyFilters(listData);
  }

  @observable
  ObservableList<AccountModel> filteredUsers = ObservableList();

  FormGroup formGroup = FormGroup({
    'search': FormControl<String>(),
  });
}
