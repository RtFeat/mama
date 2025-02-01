import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'age.g.dart';

class AgeCategoriesStore extends _AgeCategoriesStore with _$AgeCategoriesStore {
  AgeCategoriesStore({
    required super.apiClient,
  });
}

abstract class _AgeCategoriesStore extends PaginatedListStore<CategoryModel>
    with Store {
  _AgeCategoriesStore({
    required super.apiClient,
  }) : super(
          basePath: Endpoint().ageCaterories,
          fetchFunction: (params, path) =>
              ApiClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => CategoryModel.fromJson(e))
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
  ObservableList get selectedItems => ObservableList.of(
      listData.where((element) => element.isSelected).toList());

  @computed
  int get selectedItemsCount => selectedItems.length;

  @observable
  bool isConfirmed = false;

  @action
  void setConfirmed(bool value) => isConfirmed = value;
}
