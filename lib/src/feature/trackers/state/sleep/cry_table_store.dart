import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';
import 'package:uuid/uuid.dart';
import 'package:mama/src/core/api/models/sleepcry_get_cry_response.dart';

class CryTableStore extends _CryTableStore {
  CryTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _CryTableStore extends TableStore<EntityCry> with Store {
  _CryTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () => EntityCry(),
          basePath: 'sleep_cry/cry/get',
          fetchFunction: (params, path) => apiClient.get(path, queryParams: params),
          pageSize: 150,
          transformer: (raw) {
            final data = SleepcryGetCryResponse.fromJson(raw);
            return {'main': data.list ?? <EntityCry>[]};
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
  bool showAll = false; // Показывать все записи или только первые

  static const int _initialRowLimit = 5; // Количество записей по умолчанию

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          // Очищаем старые данные
          runInAction(() {
            listData.clear();
          });
          
          // Загружаем новые данные
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
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
  }

  @action
  void toggleShowAll() {
    if (!_isActive) return;
    showAll = !showAll;
  }

  @action
  void forceUpdate() {
    if (!_isActive) return;
    // Принудительно обновляем UI
    runInAction(() {
      // Триггерим реактивность
      final temp = listData.length;
      listData.length;
    });
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

  // Table for Skit (not used directly in this UI but must be implemented)
  @override
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: ['Дата', 'Начало', 'Окончание', 'Время'],
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
        ),
      );

  @override
  ObservableList<List<TableItem>> get rows {
    if (!_isActive) return ObservableList.of([]);
    
    final List<List<TableItem>> result = [];
    for (final e in listData) {
      final start = _parseToLocal(e.timeToStart);
      DateTime end = _parseToLocal(e.timeEnd);
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }
      final dur = end.difference(start).inMinutes;
      result.add([
        TableItem(title: DateFormat('dd MMMM').format(start), row: result.length + 1, column: 1),
        TableItem(title: DateFormat('HH:mm').format(start), row: result.length + 1, column: 2),
        TableItem(title: DateFormat('HH:mm').format(end), row: result.length + 1, column: 3),
        TableItem(title: _minutesToHhMm(dur), row: result.length + 1, column: 4),
      ]);
    }
    return ObservableList.of(result);
  }

  static String _minutesToHhMm(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}м';
    return '${h}ч ${m}м';
  }

  static DateTime _parseDateStatic(String? date) {
    if (date == null) return DateTime(2024, 1, 1); // Стабильное значение
    try {
      if (date.contains('T')) {
        final dt = DateTime.parse(date);
        return dt.isUtc ? dt.toLocal() : dt.toLocal();
      }
      if (date.contains(' ')) return DateFormat('yyyy-MM-dd HH:mm:ss').parse(date).toLocal();
      return DateFormat('yyyy-MM-dd').parse(date).toLocal();
    } catch (_) {
      return DateTime(2024, 1, 1); // Стабильное значение
    }
  }

  static DateTime _parseTimeStatic(String? t) {
    if (t == null) return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    try {
      return DateFormat('HH:mm').parse(t);
    } catch (_) {
      return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    }
  }

  static DateTime _parseToLocal(String? value) {
    if (value == null || value.isEmpty) return DateTime.now();
    try {
      if (value.contains('T')) {
        final dt = DateTime.parse(value);
        return dt.isUtc ? dt.toLocal() : dt.toLocal();
      }
      if (value.contains(' ')) return DateFormat('yyyy-MM-dd HH:mm:ss').parse(value).toLocal();
      if (value.contains(':')) {
        final time = DateFormat('HH:mm').parse(value);
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, time.hour, time.minute);
      }
      return DateFormat('yyyy-MM-dd').parse(value).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }
}
