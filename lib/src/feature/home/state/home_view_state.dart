import 'package:mama/src/data.dart';

class HomeViewStore {
  final ArticlesStore allArticlesStore;
  final ArticlesStore forMeArticlesStore;
  final ArticlesStore ownArticlesStore;

  final CoursesStore coursesStore;

  HomeViewStore({
    required RestClient restClient,
    required String? userId,
  })  : allArticlesStore = ArticlesStore(
          fetchFunction: (params) => restClient.get(
            Endpoint().articles,
            queryParams: params,
          ),
        ),
        forMeArticlesStore = ArticlesStore(
          fetchFunction: (params) => restClient.get(
            Endpoint().articles,
            queryParams: {
              ...params,
              if (userId != null) 'user_id': userId,
            },
          ),
        ),
        ownArticlesStore = ArticlesStore(
          fetchFunction: (params) => restClient.get(
            Endpoint().articleOwn,
            queryParams: params,
          ),
        ),
        coursesStore = CoursesStore(
          fetchFunction: (params) => restClient.get(
            Endpoint().schoolCourses,
            queryParams: params,
          ),
        );

  Future<void> loadAllArticles() async {
    await allArticlesStore.loadPage(queryParams: {});
  }

  Future<void> loadForMeArticles(String accountId) async {
    await forMeArticlesStore.loadPage(queryParams: {});
  }

  Future<void> loadOwnArticles(String accountId) async {
    await ownArticlesStore.loadPage(queryParams: {});
  }

  Future<void> loadSchoolCourses(String schoolId) async {
    await coursesStore.loadPage(queryParams: {'school_id': schoolId});
  }
}
