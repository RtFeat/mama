import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ArticlesStore extends PaginatedListStore<ArticleModel> {
  ArticlesStore({
    required super.apiClient,
    required super.fetchFunction,
  }) : super(
          basePath: Endpoint().articles,
          transformer: (raw) {
            final data = ArticlesData.fromJson(raw);
            return data.articles ?? [];
          },
        );
}
