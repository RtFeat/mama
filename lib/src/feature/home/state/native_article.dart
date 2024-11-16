import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

class NativeArticleStore extends SingleDataStore<ArticleModel> with Store {
  NativeArticleStore({
    required this.restClient,
    required String? id,
  }) : super(
          fetchFunction: () => restClient.get('${Endpoint.article}/$id'),
          transformer: (raw) {
            final data = ArticleModel.fromJson(raw?['article']);

            // author = data.author;
            // avatarUrl = data.author?.avatarUrl;
            // countArticlesAuthor = data.countArticlesAuthor;

            return data;
          },
        );

  final RestClient restClient;

  Future addToFavorite(String id) async {
    return await restClient
        .put('${Endpoint().addArticleToFavorite}/$id', body: {});
  }
}

// class NativeArticleStore extends _NativeArticleStore with _$NativeArticleStore {
//   NativeArticleStore({required super.restClient});
// }

// abstract class _NativeArticleStore
//     with Store, LoadingDataStoreExtension<ArticleModel> {
//   final RestClient restClient;

//   _NativeArticleStore({required this.restClient});

//   Future getData(String id) async {
//     return await fetchData(restClient.get('${Endpoint.article}/$id'), (v) {
//       final data = ArticleModel.fromJson(v['article']);

//       author = data.author;
//       avatarUrl = data.author?.avatarUrl;
//       countArticlesAuthor = data.countArticlesAuthor;

//       listData = ObservableList.of(data.articles ?? []);
//       return data;
//     });
//   }

//   @observable
//   String? avatarUrl;

//   @observable
//   AccountModel? author;

//   @observable
//   int? countArticlesAuthor;

//   Future addToFavorite(String id) async {
//     return await restClient
//         .put('${Endpoint().addArticleToFavorite}/$id', body: {});
//   }
// }
