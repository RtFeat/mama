import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'favorites.g.dart';

class FavoriteArticlesStore extends _FavoriteArticlesStore
    with _$FavoriteArticlesStore {
  FavoriteArticlesStore({
    required super.restClient,
  });
}

abstract class _FavoriteArticlesStore
    extends PaginatedListStore<FavoriteArticle> with Store {
  _FavoriteArticlesStore({
    required super.restClient,
  }) : super(
          basePath: Endpoint().favoriteArticles,
          fetchFunction: (params, path) =>
              restClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['articles'] ?? [])
                .map((e) => FavoriteArticle.fromJson(e))
                .toList();

            return data;
          },
        );
}
