import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ArticlesStore extends PaginatedListStore<ArticleModel> {
  ArticlesStore({
    required super.apiClient,
    required super.fetchFunction,
    required super.faker,
  }) : super(
          pageSize: 5,
          testDataGenerator: () {
            return
                // ArticlesData(
                //     articles:
                //         List.generate(faker.datatype.number(min: 5, max: 30), (_) {
                //   return
                ArticleModel.mock(faker);
            // }));
          },
          basePath: Endpoint().articles,
          transformer: (raw) {
            final data = ArticlesData.fromJson(raw);
            // return data.articles ?? [];

            return {
              'main': data.articles ?? [],
            };
          },
        );
}
