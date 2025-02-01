import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'knowledge.g.dart';

class KnowledgeStore extends _KnowledgeStore with _$KnowledgeStore {
  KnowledgeStore({
    required super.apiClient,
    required super.categoriesStore,
    required super.ageCategoriesStore,
  });
}

abstract class _KnowledgeStore extends PaginatedListStore<ArticleModel>
    with Store {
  final CategoriesStore categoriesStore;
  final AgeCategoriesStore ageCategoriesStore;

  _KnowledgeStore({
    required super.apiClient,
    required this.categoriesStore,
    required this.ageCategoriesStore,
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
}
