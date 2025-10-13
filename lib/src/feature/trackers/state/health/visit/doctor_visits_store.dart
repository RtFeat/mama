import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:mobx/mobx.dart';

part 'doctor_visits_store.g.dart';

class DoctorVisitsStore extends _DoctorVisitsStore with _$DoctorVisitsStore {
  DoctorVisitsStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
    required super.userStore,
  });
}

abstract class _DoctorVisitsStore extends LearnMoreStore<EntityMainDoctor>
    with Store {
  _DoctorVisitsStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
    required this.userStore,
  }) : super(
          testDataGenerator: () {
            //

            return EntityMainDoctor(
                // id: faker.guid(),
                // name: faker.person.name(),
                // avatarUrl: faker.internet.avatar(),
                // dataStart: format.format(DateTime.now()),
                // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),
                );
          },
          basePath: Endpoint.doctorVisit,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = HealthResponseListConsDoctor.fromJson(raw);

            // return data;

            return {
              'main': data.list ?? [],
            };
          },
        ) {
    _setupChildIdReaction();
  }

  final UserStore userStore;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

  @observable
  bool _isActive = true;

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          print('DoctorVisitsStore reaction: childId changed to $newChildId');
          
          // Используем refreshForChild для полной перезагрузки
          refreshForChild(newChildId);
        }
      },
    );
  }

  @action
  Future<void> refreshForChild(String childId) async {
    if (!_isActive || childId.isEmpty) return;
    
    print('DoctorVisitsStore refreshForChild: $childId');
    
    // Сбрасываем все данные
    runInAction(() {
      listData.clear();
      currentPage = 1;
      hasMore = true;
    });
    
    // Загружаем первую страницу
    await loadPage(
      newFilters: [
        SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: childId,
        ),
      ],
    );
    
    print('DoctorVisitsStore refreshForChild completed: ${listData.length} items loaded');
  }

  @action
  void deactivate() {
    _isActive = false;
    _childIdReaction?.call();
    _childIdReaction = null;
  }

  @action
  void activate() {
    _isActive = true;
    if (_childIdReaction == null) {
      _setupChildIdReaction();
    }
    // Загружаем данные при активации только если есть childId
    if (childId.isNotEmpty) {
      refreshForChild(childId);
    }
  }

}
