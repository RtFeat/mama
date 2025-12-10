import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart' as skit;

part 'diapers.g.dart';

class DiapersStore extends _DiapersStore with _$DiapersStore {
  DiapersStore({
    required super.apiClient,
    required super.onSet,
    required super.onLoad,
    required super.faker,
    required super.userStore,
  });
}

abstract class _DiapersStore extends LearnMoreStore<EntityDiapersMain>
    with Store {
  _DiapersStore({
    required super.onLoad,
    required super.onSet,
    required super.apiClient,
    required super.faker,
    required this.userStore,
  }) : super(
          testDataGenerator: () {
            final format = DateFormat('dd MMMM',
                LocaleSettings.currentLocale.flutterLocale.toLanguageTag());

            //

            return EntityDiapersMain(
                data: '',
                diapersSub: ObservableList.of(
                    List.generate(faker.datatype.number(min: 5, max: 20), (_) {
                  return EntityDiapersSubMain(
                    howMuch: 'Много',
                    notes: faker.lorem.sentence(),
                    time: format.format(DateTime.now()),
                    typeOfDiapers: TypeOfDiapers.mixed.name,
                  );
                })));
          },
          basePath: Endpoint.diaperList,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 20,
          transformer: (raw) {
            final data = DiapersResponseListDiapers.fromJson(raw);

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
  DateTime selectedDate = DateTime.now();

  @observable
  bool _isActive = true;

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          // Очищаем старые данные
          runInAction(() {
            listData.clear();
          });
          
          // Загружаем новые данные для выбранной недели
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    // Сбрасываем пагинацию перед загрузкой новых данных
    resetPagination();
    
    loadPage(newFilters: [
      skit.SkitFilter(
        field: 'child_id',
        operator: skit.FilterOperator.equals,
        value: childId,
      ),
      skit.SkitFilter(
        field: 'from_time',
        operator: skit.FilterOperator.equals,
        value: startOfWeek.toUtc().toIso8601String(),
      ),
      skit.SkitFilter(
        field: 'to_time',
        operator: skit.FilterOperator.equals,
        value: endOfWeek.toUtc().toIso8601String(),
      ),
    ]);
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    
    // Перезагружаем данные при изменении даты
    if (_isActive && childId.isNotEmpty) {
      _loadDataForChild(childId);
    }
  }

  @computed
  DateTime get startOfWeek => selectedDate.startOfWeek();

  @computed
  DateTime get endOfWeek => selectedDate.add(const Duration(days: 6));

  @computed
  int get averageOfDiapers {
    if (listData.isEmpty) return 0;

    final totalDiapers = listData.map((e) {
      if (e == null) return 0;
      return e.diapersSub?.length;
    }).reduce((a, b) {
      if (a == null || b == null) return 0;
      return a + b;
    });

    return (totalDiapers ?? 0) ~/ listData.length;
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
      _loadDataForChild(childId);
    }
  }
}
