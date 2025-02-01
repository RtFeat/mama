import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'categories.g.dart';

class CategoriesStore extends _CategoriesStore with _$CategoriesStore {
  CategoriesStore({
    required super.apiClient,
  });
}

abstract class _CategoriesStore extends PaginatedListStore<CategoryModel>
    with Store {
  _CategoriesStore({
    required super.apiClient,
  }) : super(
          basePath: Endpoint.categories,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
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
