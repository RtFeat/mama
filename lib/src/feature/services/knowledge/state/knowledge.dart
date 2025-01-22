import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'knowledge.g.dart';

class KnowledgeStore extends _KnowledgeStore with _$KnowledgeStore {
  KnowledgeStore({
    required super.restClient,
    required super.categoriesStore,
    required super.ageCategoriesStore,
  });
}

abstract class _KnowledgeStore extends PaginatedListStore<ArticleModel>
    with Store {
  final CategoriesStore categoriesStore;
  final AgeCategoriesStore ageCategoriesStore;

  _KnowledgeStore({
    required RestClient restClient,
    required this.categoriesStore,
    required this.ageCategoriesStore,
  }) : super(
          fetchFunction: (params) =>
              restClient.get(Endpoint().allByCategory, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['articles'] ?? [])
                .map((e) => ArticleModel.fromJson(e))
                .toList();

            return data;
          },
        );
}
