import 'package:faker_dart/faker_dart.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class HomeViewStore {
  final ArticlesStore allArticlesStore;
  final ArticlesStore forMeArticlesStore;
  final ArticlesStore ownArticlesStore;

  final CoursesStore coursesStore;

  HomeViewStore({
    required ApiClient apiClient,
    required String? userId,
    required Faker faker,
  })  : allArticlesStore = ArticlesStore(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: params,
          ),
        ),
        forMeArticlesStore = ArticlesStore(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
            queryParams: {
              ...params,
              if (userId != null) 'user_id': userId,
            },
          ),
        ),
        ownArticlesStore = ArticlesStore(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            Endpoint().articleOwn,
            queryParams: params,
          ),
        ),
        coursesStore = CoursesStore(
          faker: faker,
          apiClient: apiClient,
          fetchFunction: (params, path) => apiClient.get(
            path,
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
