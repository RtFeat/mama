import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/feed_get_food_response.dart';
import 'package:mama/src/core/api/models/entity_food.dart';

class BottleTableStore extends _BottleTableStore {
  BottleTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _BottleTableStore extends TableStore<EntityFood> with Store {
  _BottleTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () => const EntityFood(),
          basePath: 'feed/food/get',
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
  try {
    
    if (raw == null) {
      return {'main': <EntityFood>[]};
    }
    
    // API возвращает "List" с большой буквы
    final List<dynamic>? listData = raw['List'] as List<dynamic>?;
    
    final List<EntityFood> result = [];
    if (listData != null && listData.isNotEmpty) {
      for (final item in listData) {
        try {
          final Map<String, dynamic> food = item as Map<String, dynamic>;
          
          result.add(EntityFood(
            id: food['id'] as String?,
            chest: food['chest'] as int?,
            mixture: food['mixture'] as int?,
            notes: food['notes'] as String?,
            timeToEnd: food['time_to_end'] as String?,
            childId: food['child_id'] as String?,
          ));
        } catch (itemError) {
          // Пропускаем проблемные элементы вместо полного краша
          continue;
        }
      }
    }
    
    return {'main': result};
  } catch (error) {
    // Возвращаем пустой список вместо краша
    return {'main': <EntityFood>[]};
  }
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

  static const int _initialRowLimit = 6; // Количество записей по умолчанию

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
        columnHeaders: ['Дата', 'Chest', 'Mixture', 'Total'],
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
    // Безопасный доступ к listData с проверкой на инициализацию
    final data = listData;
    if (data.isNotEmpty) {
      for (final e in data) {
        final end = DateTime.tryParse(e.timeToEnd ?? '') ?? DateTime.now();
        final chest = e.chest ?? 0;
        final mixture = e.mixture ?? 0;
        final total = chest + mixture;
        result.add([
          TableItem(title: DateFormat('dd MMMM').format(end), row: result.length + 1, column: 1),
          TableItem(title: '$chest', row: result.length + 1, column: 2),
          TableItem(title: '$mixture', row: result.length + 1, column: 3),
          TableItem(title: '$total', row: result.length + 1, column: 4),
        ]);
      }
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
