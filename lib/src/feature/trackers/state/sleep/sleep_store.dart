import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'sleep_store.g.dart';

class SleepStore extends _SleepStore with _$SleepStore {
  SleepStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.userStore,
    required super.onLoad,
    required super.onSet,
  });
}

abstract class _SleepStore extends LearnMoreStore<EntitySleepHistoryTotal>
    with Store {
  _SleepStore({
    required super.apiClient,
    required this.restClient,
    required super.faker,
    required this.userStore,
    required super.onLoad,
    required super.onSet,
  }) : super(
          testDataGenerator: () {
            return EntitySleepHistoryTotal();
          },
          basePath: '/sleep_cry/sleep/history',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = SleepcryResponseHistorySleep.fromJson(raw);
            return {
              'main': data.list ?? <EntitySleepHistoryTotal>[],
            };
          },
        ) {
    _setupChildIdReaction();
  }

  final UserStore userStore;
  final RestClient restClient;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

  @observable
  bool _isActive = true;

  @observable
  SleepcryGetSleepResponse? sleepDetails;

  @observable
  bool isDetailsLoading = false;

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          // Очищаем старые данные
          runInAction(() {
            sleepDetails = null;
            listData.clear();
          });
          
          // Загружаем новые данные
          fetchSleepDetails();
        }
      },
    );
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
      fetchSleepDetails();
    }
  }

  @action
  Future<void> fetchSleepDetails() async {
    if (!_isActive || childId.isEmpty) return;
    
    runInAction(() {
      isDetailsLoading = true;
      sleepDetails = null;
    });
    
    try {
      final response = await restClient.sleepCry.getSleepCrySleepGet(childId: childId);
      if (_isActive) {
        runInAction(() => sleepDetails = response);
      }
    } catch (e) {
      // Error fetching sleep details
    } finally {
      if (_isActive) {
        runInAction(() => isDetailsLoading = false);
      }
    }
  }
}
