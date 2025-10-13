import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

class BreastFeedingTableStore extends _BreastFeedingTableStore {
  BreastFeedingTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _BreastFeedingTableStore extends TableStore<EntityFeeding> with Store {
  _BreastFeedingTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () => EntityFeeding(),
          basePath: 'feed/chest/history',
          fetchFunction: (params, path) => apiClient.get(path, queryParams: params),
          pageSize: 150,
          transformer: (raw) {
            final data = FeedResponseHistoryChest.fromJson(raw);
            final List<EntityFeeding> result = [];
            for (final total in data.list ?? []) {
              // API provides list of EntityChestHistory in 'chest_history'
              if (total.chestHistory != null) {
                // Use provided total end date as base day for each entry
                final baseDate = _parseDateStatic(total.timeToEndTotal);
                for (final c in total.chestHistory!) {
                  final end = _parseTimeStatic(c.time);
                  final endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, end.hour, end.minute);
                  result.add(EntityFeeding(
                    id: '${c.time}_${DateTime.now().millisecondsSinceEpoch}',
                    childId: '',
                    timeToEnd: endDateTime.toIso8601String(),
                    leftFeeding: c.left,
                    rightFeeding: c.right,
                    allFeeding: c.total,
                    notes: c.notes,
                  ));
                }
              }
            }
            return {'main': result};
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
  bool showAll = false; // Показывать все записи или только первые

  @observable
  bool _isActive = true;

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
    
    print('BreastFeedingTableStore _loadDataForChild: Loading for childId: $childId');
    
    // Используем метод refreshForChild для полной перезагрузки
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
    
    print('BreastFeedingTableStore refreshForChild: $childId');
    
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
    
    print('BreastFeedingTableStore refreshForChild completed: ${listData.length} items loaded');
  }

  @action
  void toggleShowAll() {
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
    final List<List<TableItem>> result = [];
    for (final e in listData) {
      final end = DateTime.tryParse(e.timeToEnd ?? '') ?? DateTime.now();
      final leftMinutes = e.leftFeeding ?? 0;
      final rightMinutes = e.rightFeeding ?? 0;
      final totalMinutes = e.allFeeding ?? 0;
      
      result.add([
        TableItem(title: DateFormat('dd MMMM').format(end), row: result.length + 1, column: 1),
        TableItem(title: '${leftMinutes}м', row: result.length + 1, column: 2),
        TableItem(title: '${rightMinutes}м', row: result.length + 1, column: 3),
        TableItem(title: _minutesToHhMm(totalMinutes), row: result.length + 1, column: 4),
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
    if (date == null) return DateTime.now();
    try {
      if (date.contains('T')) return DateTime.parse(date);
      if (date.contains(' ')) return DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      return DateFormat('yyyy-MM-dd').parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  static DateTime _parseTimeStatic(String? time) {
    if (time == null) return DateTime.now();
    try {
      return DateFormat('HH:mm').parse(time);
    } catch (_) {
      return DateTime.now();
    }
  }
}
