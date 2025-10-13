import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/feed_get_feeding_response.dart';

class PumpingTableStore extends _PumpingTableStore {
  PumpingTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _PumpingTableStore extends TableStore<EntityPumpingHistory> with Store {
  _PumpingTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () => const EntityPumpingHistory(),
          basePath: 'feed/pumping/get',
          fetchFunction: (params, path) async {
            try {
              // Use apiClient.get like other stores
              final response = await apiClient.get(path, queryParams: params);
              return response;
            } catch (error) {
              rethrow;
            }
          },
          pageSize: 150,
          transformer: (raw) {
            // API возвращает "List" с большой буквы, а не "list"
            final List<dynamic>? listData = raw['List'] as List<dynamic>?;
            
            final List<EntityPumpingHistory> result = [];
            if (listData != null) {
              for (final item in listData) {
                final Map<String, dynamic> feeding = item as Map<String, dynamic>;
                
                // Parse time_to_end to get the end time
                final endTime = _parseDateStatic(feeding['time_to_end'] as String?);
                
                // Use the ID from API if available, otherwise create a fallback
                final recordId = feeding['id'] as String? ?? 'temp_${endTime.millisecondsSinceEpoch}_${feeding['left_feeding']}_${feeding['right_feeding']}';
                
                result.add(EntityPumpingHistory(
                  id: recordId,
                  left: feeding['left_feeding'] as int? ?? 0,
                  right: feeding['right_feeding'] as int? ?? 0,
                  total: feeding['all_feeding'] as int? ?? ((feeding['left_feeding'] as int? ?? 0) + (feeding['right_feeding'] as int? ?? 0)),
                  time: endTime.toIso8601String(),
                  notes: feeding['notes'] as String?,
                ));
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
  bool _isActive = true;

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
    
    print('PumpingTableStore _loadDataForChild: Loading for childId: $childId');
    
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
    
    print('PumpingTableStore refreshForChild: $childId');
    
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
    
    print('PumpingTableStore refreshForChild completed: ${listData.length} items loaded');
  }

  @override
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: ['Дата', 'Left', 'Right', 'Total'],
        columnWidths: const {0: 2, 1: 1, 2: 1, 3: 1},
        rows: rows,
        cellDecoration: CellDecoration(
          headerStyle: AppTextStyles.f10w700.copyWith(color: AppColors.greyBrighterColor),
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
      final end = DateTime.tryParse(e.time ?? '') ?? DateTime.now();
      final left = e.left ?? 0;
      final right = e.right ?? 0;
      final total = e.total ?? (left + right);
      result.add([
        TableItem(title: DateFormat('dd MMMM').format(end), row: result.length + 1, column: 1),
        TableItem(title: '$left', row: result.length + 1, column: 2),
        TableItem(title: '$right', row: result.length + 1, column: 3),
        TableItem(title: '$total', row: result.length + 1, column: 4),
      ]);
    }
    return ObservableList.of(result);
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
}


