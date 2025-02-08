import 'package:collection/collection.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'knowledge.g.dart';

class KnowledgeStore extends _KnowledgeStore with _$KnowledgeStore {
  KnowledgeStore({
    required super.apiClient,
    required super.categoriesStore,
    required super.ageCategoriesStore,
    required super.authorsStore,
  });
}

abstract class _KnowledgeStore extends PaginatedListStore<ArticleModel>
    with Store {
  final CategoriesStore categoriesStore;
  final AgeCategoriesStore ageCategoriesStore;
  final AuthorsStore authorsStore;

  _KnowledgeStore({
    required super.apiClient,
    required this.categoriesStore,
    required this.ageCategoriesStore,
    required this.authorsStore,
  }) : super(
          basePath: Endpoint().allByCategory,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['articles'] ?? [])
                .map((e) => ArticleModel.fromJson(e))
                .toList();

            return data;
          },
        );

  void onConfirm() {
    categoriesStore.setConfirmed(true);
    ageCategoriesStore.setConfirmed(true);
    authorsStore.setConfirmed(true);

    resetPagination();

    loadPage(queryParams: {
      'category': categoriesStore.selectedItems.map((e) => e.title).toList(),
      'age_category':
          ageCategoriesStore.selectedItems.map((e) => e.title).toList(),
      'accounts': authorsStore.selectedItems
          .where((e) => e.isSelected)
          .map((e) => e.writer?.accountId)
          .toList(),
      if (authorsStore.selectedItems.firstWhereOrNull((e) => e.isSelected) !=
          null)
        'account_id': authorsStore.selectedItems
            .firstWhereOrNull((e) => e.isSelected)
            ?.writer
            ?.accountId
    });
  }
}
