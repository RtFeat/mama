import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'age.g.dart';

class AgeCategoriesStore extends _AgeCategoriesStore with _$AgeCategoriesStore {
  AgeCategoriesStore({
    required super.apiClient,
  });
}

abstract class _AgeCategoriesStore extends PaginatedListStore<AgeCategoryModel>
    with Store {
  _AgeCategoriesStore({
    required super.apiClient,
  }) : super(
          basePath: Endpoint().ageCaterories,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => AgeCategoryModel.fromJson(e))
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
  ObservableList<AgeCategoryModel> get selectedItems => ObservableList.of(
      listData.where((element) => element.isSelected).toList());

  @computed
  int get selectedItemsCount => selectedItems.length;

  @observable
  bool isConfirmed = false;

  @action
  void setConfirmed(bool value) => isConfirmed = value;
}
