import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'authors.g.dart';

class AuthorsStore extends _AuthorsStore with _$AuthorsStore {
  AuthorsStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _AuthorsStore extends PaginatedListStore<AuthorModel>
    with Store {
  _AuthorsStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return AuthorModel(
                count: faker.datatype.number(),
                writer: WriterModel(
                  accountId: faker.datatype.uuid(),
                  firstName: faker.name.firstName(),
                  lastName: faker.name.lastName(),
                  photoId: faker.datatype.uuid(),
                  profession: faker.commerce.department(),
                  role: Role.values[faker.datatype
                      .number(min: 0, max: Role.values.length - 1)],
                ));
          },
          basePath: Endpoint().authorCaterories,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => AuthorModel.fromJson(e))
                .toList();

            return data;
          },
        );

  @action
  void setMarkAllNotSelected() {
    for (var element in listData) {
      element.setSelected(false);
    }
  }

  @computed
  ObservableList<AuthorModel> get selectedItems => ObservableList.of(
      listData.where((element) => element.isSelected).toList());

  @computed
  int get selectedItemsCount => selectedItems.length;

  @observable
  bool isConfirmed = false;

  @action
  void setConfirmed(bool value) => isConfirmed = value;
}
