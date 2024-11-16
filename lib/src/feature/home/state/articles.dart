import 'package:mama/src/data.dart';

class ArticlesStore extends PaginatedListStore<ArticleModel> {
  ArticlesStore({
    required super.fetchFunction,
  }) : super(
          transformer: (raw) {
            final data = ArticlesData.fromJson(raw);
            return data.articles ?? [];
          },
        );
}
