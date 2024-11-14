import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'native_article.g.dart';

class NativeArticleStore extends _NativeArticleStore with _$NativeArticleStore {
  NativeArticleStore({required super.restClient});
}

abstract class _NativeArticleStore with Store, BaseStore<ArticleModel> {
  final RestClient restClient;

  _NativeArticleStore({required this.restClient});

  Future getData(String id) async {
    return await fetchData(restClient.get('${Endpoint.article}/$id'), (v) {
      final data = ArticleModel.fromJson(v['article']);

      author = data.author;
      avatarUrl = data.author?.avatarUrl;
      countArticlesAuthor = data.countArticlesAuthor;

      listData = ObservableList.of(data.articles ?? []);
      return data;
    });
  }

  @observable
  String? avatarUrl;

  @observable
  AccountModel? author;

  @observable
  int? countArticlesAuthor;

  Future addToFavorite(String id) async {
    return await restClient
        .put('${Endpoint().addArticleToFavorite}/$id', body: {});
  }
}
