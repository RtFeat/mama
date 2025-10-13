import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'evolution_table.g.dart';

enum EntityDataNormal {
  bad,
  normal,
  good,
}

class EvolutionTableStore extends _EvolutionTableStore
    with _$EvolutionTableStore {
  EvolutionTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
    required super.userStore,
  });
}

abstract class _EvolutionTableStore extends TableStore<EntityTable> with Store {
  _EvolutionTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
    required this.userStore,
  }) : super(
          testDataGenerator: () {
            return EntityTable();
          },
          basePath: 'growth/table/new',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 50,
          transformer: (raw) {
            final data = GrowthGetTableResponse.fromJson(raw);
            return {
              'main': data.list ?? <EntityTable>[],
            };
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
  WeightUnit weightUnit = WeightUnit.kg; // 'kg' or 'g'

  @observable
  CircleUnit circleUnit = CircleUnit.cm;

  void _setupChildIdReaction() {
    _childIdReaction = reaction(
      (_) => childId,
      (String newChildId) {
        if (_isActive && newChildId.isNotEmpty) {
          print('EvolutionTableStore reaction: childId changed to $newChildId');
          
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
    
    print('EvolutionTableStore _loadDataForChild: Loading for childId: $childId');
    
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
    
    print('EvolutionTableStore refreshForChild: $childId');
    
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
    
    print('EvolutionTableStore refreshForChild completed: ${listData.length} items loaded');
  }

  @action
  void setSortOrder(int index) {
    if (!_isActive) return;
    sortOrder = index == 0 ? 'new' : 'old';
  }

  @action
  void setWeightUnit(WeightUnit unit) {
    if (!_isActive) return;
    weightUnit = unit;
  }

  @action
  void setCircleUnit(CircleUnit unit) {
    if (!_isActive) return;
    circleUnit = unit;
  }

  /// Форматирует значение недели, убирая минус если он есть
  String _formatWeeks(String? weeks) {
    if (weeks == null || weeks.isEmpty) return '0';
    
    // Убираем минус если он есть
    final cleanWeeks = weeks.startsWith('-') ? weeks.substring(1) : weeks;
    
    // Проверяем, что это число
    final weeksInt = int.tryParse(cleanWeeks);
    if (weeksInt == null) return '0';
    
    return weeksInt.toString();
  }

  @override
  TableData get tableData => TableData(
      headerTitle: '',
      columnHeaders: [
        t.trackers.evolutionTableTitles.title1,
        t.trackers.evolutionTableTitles.title2,
        t.trackers.evolutionTableTitles.title3,
        t.trackers.evolutionTableTitles.title4,
        t.trackers.evolutionTableTitles.title5,
      ],
      columnWidths: {
        0: 2,
        1: 1,
        2: 1,
        3: 1,
        4: 1,
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

    final sortedList = List<EntityTable>.from(listData);
    sortedList.sort((a, b) {
      final dateStringA = a.dateTime ?? a.data ?? '';
      final dateStringB = b.dateTime ?? b.data ?? '';

      if (sortOrder == 'new') {
        return dateStringB.compareTo(dateStringA);
      } else {
        return dateStringA.compareTo(dateStringB);
      }
    });

    for (var i = 0; i < sortedList.length; i++) {
      final entity = sortedList[i];
      // final temp = tempHistory[colIdx];
      final bool hasNote = entity.notes != null && entity.notes!.isNotEmpty;

      const outOfNorm = 'Вне нормы';
      const inNorm = 'Граница нормы';

      var isWeightNorm = EntityDataNormal.normal;
      var isGrowthNorm = EntityDataNormal.normal;
      var isCircleNorm = EntityDataNormal.normal;

      switch (entity.normalWeight) {
        case outOfNorm:
          isWeightNorm = EntityDataNormal.bad;
          break;
        case inNorm:
          isWeightNorm = EntityDataNormal.good;
          break;
        default:
          isWeightNorm = EntityDataNormal.normal;
      }

      switch (entity.normalHeight) {
        case outOfNorm:
          isGrowthNorm = EntityDataNormal.bad;
          break;
        case inNorm:
          isGrowthNorm = EntityDataNormal.good;
          break;
        default:
          isGrowthNorm = EntityDataNormal.normal;
      }

      switch (entity.normalCircle) {
        case outOfNorm:
          isCircleNorm = EntityDataNormal.bad;
          break;
        case inNorm:
          isCircleNorm = EntityDataNormal.good;
          break;
        default:
          isCircleNorm = EntityDataNormal.normal;
      }

      final weightValue = double.tryParse(entity.weight ?? '') ?? 0.0;
      final displayWeight = weightUnit == WeightUnit.g
          ? weightValue == 0.0
              ? ''
              : (weightValue * 1000).toStringAsFixed(0)
          : entity.weight;

      final growthValue = double.tryParse(entity.height ?? '') ?? 0.0;
      final displayGrowth = circleUnit == CircleUnit.m
          ? growthValue == 0.0
              ? ''
              : (growthValue / 100).toStringAsFixed(2)
          : entity.height;

      final circleValue = double.tryParse(entity.circle ?? '') ?? 0.0;
      final displayCircle = circleUnit == CircleUnit.m
          ? circleValue == 0.0
              ? ''
              : (circleValue / 100).toStringAsFixed(2)
          : entity.circle;

      result.add([
        TableItem(
          title: entity.data.toString(),
          row: result.length + 1,
          column: 1,
          isHide: false,
          trailing: hasNote
              ? Row(
                  children: [
                    NoteIconWidget(
                      size: 20,
                    ),
                  ],
                )
              : null,
        ),
        TableItem(
          title: _formatWeeks(entity.week),
          row: result.length + 1,
          column: 2,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        TableItem(
          title: displayWeight,
          row: result.length + 1,
          column: 3,
          mainAxisAlignment: MainAxisAlignment.center,
          decoration: isWeightNorm == EntityDataNormal.bad ||
                  isWeightNorm == EntityDataNormal.good
              ? CellDecoration(
                  color: isWeightNorm == EntityDataNormal.bad
                      ? AppColors.yellowBackgroundColor
                      : AppColors.greenLighterBackgroundColor,
                  radius: 8,
                )
              : null,
        ),
        TableItem(
          title: displayGrowth,
          row: result.length + 1,
          column: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          decoration: isGrowthNorm == EntityDataNormal.bad ||
                  isGrowthNorm == EntityDataNormal.good
              ? CellDecoration(
                  color: isGrowthNorm == EntityDataNormal.bad
                      ? AppColors.yellowBackgroundColor
                      : AppColors.greenLighterBackgroundColor,
                  radius: 8,
                )
              : null,
        ),
        TableItem(
          title: displayCircle,
          row: result.length + 1,
          column: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          decoration: isCircleNorm == EntityDataNormal.bad ||
                  isCircleNorm == EntityDataNormal.good
              ? CellDecoration(
                  color: isCircleNorm == EntityDataNormal.bad
                      ? AppColors.yellowBackgroundColor
                      : AppColors.greenLighterBackgroundColor,
                  radius: 8,
                )
              : null,
        ),
      ]);
    }
    return ObservableList.of(result);
  }
}
