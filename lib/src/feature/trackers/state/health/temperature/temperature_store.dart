import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'temperature_store.g.dart';

class TemperatureStore extends _TemperatureStore with _$TemperatureStore {
  TemperatureStore({
    required super.apiClient,
    required super.faker,
    required super.userStore,
  });
}

abstract class _TemperatureStore
    extends TableStore<EntityTemperatureHistoryTotal> with Store {
  _TemperatureStore({
    required super.apiClient,
    required super.faker,
    required this.userStore,
  }) : super(
          pageSize: 50,
          testDataGenerator: () {
            return EntityTemperatureHistoryTotal();
            // return SleepCryCell(
            //   title: faker.lorem.word(),
            //   sleep:
            //       '${faker.datatype.number(max: 10).toString()} ч ${faker.datatype.number(max: 60).toString()} м',
            //   cry:
            //       '${faker.datatype.number(max: 10).toString()} ч ${faker.datatype.number(max: 60).toString()} м',
            // );
          },
          basePath: Endpoint.temperatureHistory,
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => EntityTemperatureHistoryTotal.fromJson(e))
                .toList();

            // return data;

            return {
              'main': data,
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
          _loadDataForChild(newChildId);
        }
      },
    );
  }

  void _loadDataForChild(String childId) {
    if (!_isActive || childId.isEmpty) return;
    
    print('TemperatureStore _loadDataForChild: Loading for childId: $childId');
    
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
    
    print('TemperatureStore refreshForChild: $childId');
    
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
    
    print('TemperatureStore refreshForChild completed: ${listData.length} items loaded');
  }

  static const _cellTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: 17,
    fontFamily: 'SFProText',
  );

  @override
  @computed
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: [
          t.trackers.date.title,
          t.trackers.time.title,
          t.trackers.temperature.title
        ],
        columnWidths: {
          // 0: 2,
        },
        rows: rows,
        cellDecoration: CellDecoration(
          headerStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            fontFamily: 'SFProText',
            color: AppColors.greyBrighterColor,
          ),
          textStyle: _cellTextStyle,
        ),
      );

  @override
  @computed
  ObservableList<List<TableItem>> get rows {
    final List<List<TableItem>> result = [];
    for (final entity in listData) {
      final tempHistory = entity.temperatureHistory ?? [];
      if (tempHistory.isEmpty) continue; // Skip if no temperature history
      
      for (int colIdx = 0; colIdx < tempHistory.length; colIdx++) {
        final temp = tempHistory[colIdx];
        if (temp == null) continue; // Skip null temperature entries
        
        final bool hasNote = temp.notes != null && temp.notes!.isNotEmpty;

        result.add([
          TableItem(
            title: colIdx == 0 ? (entity.title ?? '') : '',
            row: result.length + 1,
            column: 1,
          ),
          TableItem(
            title: temp.time?.toString() ?? '',
            row: result.length + 1,
            column: 2,
            trailing: hasNote
                ? SizedBox(
                    height: 26,
                  )
                : null,
            decoration: (temp.isBad ?? false)
                ? CellDecoration(
                    color: AppColors.yellowBackgroundColor,
                    radius: 8,
                    textStyle: _cellTextStyle,
                  )
                : null,
          ),
          TableItem(
            title: temp.temperatures ?? '',
            row: result.length + 1,
            column: 3,
            trailing: hasNote
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const NoteIconWidget(),
                    ],
                  )
                : null,
            decoration: (temp.isBad ?? false)
                ? CellDecoration(
                    color: AppColors.yellowBackgroundColor,
                    radius: 8,
                    textStyle: _cellTextStyle,
                  )
                : null,
          ),
        ]);
      }
    }
    return ObservableList.of(result);
  }
}
