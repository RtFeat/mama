import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/sleepcry_get_sleep_response.dart';

part 'sleep_table_store.g.dart';

class SleepTableStore extends _SleepTableStore with _$SleepTableStore {
  SleepTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _SleepTableStore extends TableStore<EntitySleep> with Store {
  _SleepTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () => EntitySleep(),
          basePath: 'sleep_cry/sleep/get',
          fetchFunction: (params, path) => apiClient.get(path, queryParams: params),
          pageSize: 150,
          transformer: (raw) {
            final data = SleepcryGetSleepResponse.fromJson(raw);
            return {'main': data.list ?? <EntitySleep>[]};
          },
        ) {
    _setupChildIdReaction();
  }

  final RestClient restClient;
  final UserStore userStore;
  ReactionDisposer? _childIdReaction;

  @computed
  String get childId => userStore.selectedChild?.id ?? '';

  @observable
  bool _isActive = true;

  @observable
  String sortOrder = 'new'; // 'new' or 'old'

  @observable
  bool showAll = false; // Показывать все записи или только первые

  static const int _initialRowLimit = 5; // Количество записей по умолчанию

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    print('SleepTableStore _loadDataForChild: Loading for childId: $childId');
    
    // Используем новый метод refreshForChild для полной перезагрузки
    refreshForChild(childId);
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

  @action
  Future<void> refreshForChild(String childId) async {
    if (!_isActive || childId.isEmpty) return;
    
    print('SleepTableStore refreshForChild: $childId');
    
    // Сбрасываем все данные
    runInAction(() {
      listData.clear();
      currentPage = 1;
      hasMore = true;
      showAll = false;
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
    
    print('SleepTableStore refreshForChild completed: ${listData.length} items loaded');
  }

  @action
  void setSortOrder(int index) {
    if (!_isActive) return;
    sortOrder = index == 0 ? 'new' : 'old';
  }

  @action
  void toggleShowAll() {
    if (!_isActive) return;
    showAll = !showAll;
  }

  @computed
  int get totalRecordsCount => listData.length;

  @computed
  int get shownRecordsCount {
    if (showAll) return totalRecordsCount;
    return totalRecordsCount > _initialRowLimit ? _initialRowLimit : totalRecordsCount;
  }

  @computed
  bool get canShowAll => !showAll && totalRecordsCount > _initialRowLimit;

  @computed
  bool get canCollapse => showAll;

  @override
  TableData get tableData => TableData(
      headerTitle: '',
      columnHeaders: [
        'Дата',
        'Начало',
        'Окончание',
        'Время',
      ],
      columnWidths: {
        0: 2,
        1: 1,
        2: 1,
        3: 1,
      },
      rows: rows,
      cellDecoration: CellDecoration(
        headerStyle: AppTextStyles.f10w700.copyWith(
          color: AppColors.greyBrighterColor,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'SFProText',
        ),
      ));

  @override
  @computed
  ObservableList<List<TableItem>> get rows {
    if (!_isActive) return ObservableList.of([]);
    
    final List<List<TableItem>> result = [];

    final sortedList = List<EntitySleep>.from(listData);
    sortedList.sort((a, b) {
      final dateStringA = a.timeToStart ?? '';
      final dateStringB = b.timeToStart ?? '';

      if (sortOrder == 'new') {
        return dateStringB.compareTo(dateStringA);
      } else {
        return dateStringA.compareTo(dateStringB);
      }
    });

    for (var i = 0; i < sortedList.length; i++) {
      final entity = sortedList[i];
      final startTime = _parseDateTime(entity.timeToStart);
      final endTime = _parseDateTime(entity.timeEnd);
      final duration = endTime.difference(startTime);

      result.add([
        TableItem(
          title: _formatDate(startTime),
          row: result.length + 1,
          column: 1,
        ),
        TableItem(
          title: _formatTime(startTime),
          row: result.length + 1,
          column: 2,
        ),
        TableItem(
          title: _formatTime(endTime),
          row: result.length + 1,
          column: 3,
        ),
        TableItem(
          title: _formatDuration(duration.inMinutes),
          row: result.length + 1,
          column: 4,
        ),
      ]);
    }

    return ObservableList.of(result);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM').format(date);
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '${mins}м';
    return '${hours}ч ${mins}м';
  }

  DateTime _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return DateTime.now();
    
    try {
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      } else {
        return DateFormat('yyyy-MM-dd').parse(dateTimeString);
      }
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime _parseDateTimeStatic(String? dateTimeString) {
    if (dateTimeString == null) return DateTime(2024, 1, 1); // Стабильное значение
    
    try {
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      } else {
        return DateFormat('yyyy-MM-dd').parse(dateTimeString);
      }
    } catch (e) {
      return DateTime(2024, 1, 1); // Стабильное значение
    }
  }

  static DateTime _parseTimeOnlyStatic(String? timeString) {
    if (timeString == null) return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    
    try {
      return DateFormat('HH:mm').parse(timeString);
    } catch (e) {
      return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    }
  }
}