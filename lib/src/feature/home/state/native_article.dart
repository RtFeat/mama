import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'native_article.g.dart';

class NativeArticleStore extends _NativeArticleStore with _$NativeArticleStore {
  NativeArticleStore({required super.restClient});
}

abstract class _NativeArticleStore with Store, BaseStore {
  final RestClient restClient;

  _NativeArticleStore({required this.restClient});

  Future getData(String id) async {
    return await fetchData(restClient.get('${Endpoint().nativeArticle}/$id'),
        (v) {
      final data = NativeArticles.fromJson(v);

      listData = ObservableList.of(data.articles ?? []);
      return data;
    });
  }

  Future addToFavorite(String id) async {
    return await restClient
        .put('${Endpoint().addArticleToFavorite}/$id', body: {});
  }
}
