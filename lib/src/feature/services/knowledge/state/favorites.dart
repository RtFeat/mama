import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'favorites.g.dart';

class FavoriteArticlesStore extends _FavoriteArticlesStore
    with _$FavoriteArticlesStore {
  FavoriteArticlesStore({
    required super.apiClient,
  });
}

abstract class _FavoriteArticlesStore
    extends PaginatedListStore<FavoriteArticle> with Store {
  _FavoriteArticlesStore({
    required super.apiClient,
  }) : super(
          basePath: Endpoint().favoriteArticles,
          fetchFunction: (params, path) =>
              ApiClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['articles'] ?? [])
                .map((e) => FavoriteArticle.fromJson(e))
                .toList();

            return data;
          },
        );
}
