import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'sleep_store.g.dart';

class SleepStore extends _SleepStore with _$SleepStore {
  SleepStore({
    required super.apiClient,
    required super.restClient,
    required super.faker,
    required super.childId,
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
    required this.childId,
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
        );

  final String childId;
  final RestClient restClient;

  @observable
  SleepcryGetSleepResponse? sleepDetails;

  @observable
  bool isDetailsLoading = false;

  @action
  Future<void> fetchSleepDetails() async {
    isDetailsLoading = true;
    try {
      sleepDetails =
          await restClient.sleepCry.getSleepCrySleepGet(childId: childId);
    } catch (e) {
      // Игнорируем ошибки
    } finally {
      isDetailsLoading = false;
    }
  }
}
