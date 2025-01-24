import 'package:mama/src/data.dart';

class ArticlesStore extends PaginatedListStore<ArticleModel> {
  ArticlesStore({
    required super.restClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().articles,
          transformer: (raw) {
            final data = ArticlesData.fromJson(raw);
            return data.articles ?? [];
          },
        );
}
