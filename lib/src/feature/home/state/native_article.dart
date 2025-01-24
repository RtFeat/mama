import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

class NativeArticleStore extends SingleDataStore<ArticleModel> with Store {
  NativeArticleStore({
    required this.restClient,
    required String? id,
  }) : super(
          fetchFunction: (_) => restClient.get('${Endpoint.article}/$id'),
          transformer: (raw) {
            final data = ArticleModel.fromJson(raw?['article']);

            return data;
          },
        );

  final RestClient restClient;

  Future toggleFavorite(String id) async {
    if (data?.isFavorite ?? false) {
      await restClient.delete(Endpoint().articleToggleFavorite, body: {
        'article_id': id,
      });
    } else {
      await restClient.put('${Endpoint().articleToggleFavorite}/$id', body: {});
    }
    data?.setFavorite(!(data?.isFavorite ?? false));
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
