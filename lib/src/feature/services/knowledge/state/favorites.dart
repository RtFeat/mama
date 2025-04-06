import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'favorites.g.dart';

class FavoriteArticlesStore extends _FavoriteArticlesStore
    with _$FavoriteArticlesStore {
  FavoriteArticlesStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _FavoriteArticlesStore
    extends PaginatedListStore<FavoriteArticle> with Store {
  _FavoriteArticlesStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return FavoriteArticle(
              id: faker.datatype.uuid(),
              title: faker.lorem.word(),
              author: faker.lorem.word(),
              profession: faker.lorem.word(),
              avatarUrl: faker.image.image(),
              category: faker.lorem.word(),
              ageCategory: List.generate(
                  faker.datatype.number(max: 5),
                  (_) => AgeCategory.values[faker.datatype
                      .number(max: AgeCategory.values.length - 1)]),
              articlePhotoUrl: faker.image.image(),
            );
          },
          basePath: Endpoint().favoriteArticles,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['articles'] ?? [])
                .map((e) => FavoriteArticle.fromJson(e))
                .toList();

            // return data;

            return {
              'main': data,
            };
          },
        );
}
