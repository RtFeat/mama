import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:mobx/mobx.dart';

part 'drugs_store.g.dart';

class DrugsStore extends _DrugsStore with _$DrugsStore {
  DrugsStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
    required super.userStore,
  });
}

abstract class _DrugsStore extends LearnMoreStore<EntityMainDrug> with Store {
  _DrugsStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
    required this.userStore,
  }) : super(
          testDataGenerator: () {
            //

            return EntityMainDrug(
              // id: faker.guid(),
              // name: faker.person.name(),
              // avatarUrl: faker.internet.avatar(),
              // dataStart: format.format(DateTime.now()),
              // dataEnd: format.format(DateTime.now().add(const Duration(days: 1))),

              reminder: ObservableList(),
              reminderAfter: ObservableList(),
            );
          },
          basePath: Endpoint.drugs,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = HealthResponseListDrug.fromJson(raw);

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
          print('DrugsStore reaction: childId changed to $newChildId');
          
          // Используем refreshForChild для полной перезагрузки
          refreshForChild(newChildId);
        }
      },
    );
  }

  @action
  Future<void> refreshForChild(String childId) async {
    if (!_isActive || childId.isEmpty) return;
    
    print('DrugsStore refreshForChild: $childId');
    
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
    
    print('DrugsStore refreshForChild completed: ${listData.length} items loaded');
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

  @observable
  bool isShowCompleted = false;

  @action
  void setIsShowCompleted(bool value) {
    isShowCompleted = value;
  }

  @computed
  ObservableList get completedList => ObservableList.of(listData
      .where((e) => e is EntityMainDrug && (e.isEnd ?? false))
      .toList());
}
