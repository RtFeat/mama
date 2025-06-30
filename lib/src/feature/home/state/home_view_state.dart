import 'package:faker_dart/faker_dart.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

import 'package:mobx/mobx.dart';

part 'home_view_state.g.dart';

class HomeViewStore extends _HomeViewStore with _$HomeViewStore {
  final ArticlesStore allArticlesStore;
  final ArticlesStore forMeArticlesStore;
  final ArticlesStore ownArticlesStore;

  final CoursesStore coursesStore;

  // final ApiClient apiClient;

  HomeViewStore({
    required super.apiClient,
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

  Future<void> loadAllArticles({
    String? accountId,
  }) async {
    List<SkitFilter> filters = [];
    if (accountId != null) {
      filters.add(SkitFilter(
          field: 'account_id',
          operator: FilterOperator.equals,
          value: accountId));
    }

    await allArticlesStore.loadPage(newFilters: filters);
  }

  Future<void> loadForMeArticles(String accountId) async {
    await forMeArticlesStore.loadPage();
  }

  Future<void> loadOwnArticles(String accountId) async {
    await ownArticlesStore.loadPage();
  }

  Future<void> loadSchoolCourses(String schoolId) async {
    await coursesStore.loadPage(
      newFilters: [
        SkitFilter(
            field: 'school_id',
            operator: FilterOperator.equals,
            value: schoolId),
      ],
    );
  }
}

abstract class _HomeViewStore with Store {
  final ApiClient apiClient;

  _HomeViewStore({
    required this.apiClient,
  });

  @observable
  DoctorData? doctorData;

  @action
  Future loadDoctorData(String id) async {
    await apiClient.get('${Endpoint.doctor}/$id').then((v) {
      doctorData = DoctorData.fromJson(v!);
    });
  }
}
