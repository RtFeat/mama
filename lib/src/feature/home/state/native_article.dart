import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

class NativeArticleStore extends SingleDataStore<ArticleModel> with Store {
  NativeArticleStore({
    required super.apiClient,
    required super.faker,
    required String? id,
  }) : super(
          testDataGenerator: () {
            return ArticleModel.mock(faker);
          },
          fetchFunction: (_) => apiClient.get('${Endpoint.article}/$id'),
          transformer: (raw) {
            final data = ArticleModel.fromJson(raw?['article']);

            return data;
          },
        );

  Future toggleFavorite(String id) async {
    if (data?.isFavorite ?? false) {
      await apiClient.delete(Endpoint().articleToggleFavorite, body: {
        'article_id': id,
      });
    } else {
      await apiClient.put('${Endpoint().articleToggleFavorite}/$id', body: {});
    }
    data?.setFavorite(!(data?.isFavorite ?? false));
  }
}

// class NativeArticleStore extends _NativeArticleStore with _$NativeArticleStore {
//   NativeArticleStore({required super.apiClient});
// }

// abstract class _NativeArticleStore
//     with Store, LoadingDataStoreExtension<ArticleModel> {
//   final ApiClient apiClient;

//   _NativeArticleStore({required super.apiClient});

//   Future getData(String id) async {
//     return await fetchData(ApiClient.get('${Endpoint.article}/$id'), (v) {
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
//     return await ApiClient
//         .put('${Endpoint().addArticleToFavorite}/$id', body: {});
//   }
// }
