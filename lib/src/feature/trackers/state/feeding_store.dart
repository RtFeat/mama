import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'feeding_store.g.dart';

class FeedingStore extends _FeedingStore with _$FeedingStore {
  FeedingStore({
    required super.apiClient,
    required super.faker,
    required super.userStore,
  });
}

abstract class _FeedingStore extends TableStore<FeedingCell> with Store {
  _FeedingStore({
    required super.apiClient,
    required super.faker,
    required this.userStore,
  }) : super(
          pageSize: 50,
          testDataGenerator: () {
            return FeedingCell(table: [
              FeedingCellTable(
                title: faker.lorem.word(),
                chest:
                    '${faker.datatype.number(max: 10).toString()} ч ${faker.datatype.number(max: 60).toString()} м',
                food: faker.datatype.number(max: 500).toString(),
                lure: faker.datatype.number(max: 500).toString(),
              ),
            ], title: '${faker.datatype.number(max: 10).toString()} месяца');
          },
          basePath: Endpoint().feedTable,
          fetchFunction: (params, path) =>
              apiClient.get('$path/new', queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => FeedingCell.fromJson(e))
                .toList();

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
    
    // Сбрасываем все данные
    runInAction(() {
      listData.clear();
      currentPage = 1;
      hasMore = true;
    });
    
    // Загружаем первую страницу
    loadPage(
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

  /// Исправляет заголовок на основе реального возраста ребенка
  String _fixTitle(String? originalTitle) {
    if (originalTitle == null || originalTitle.isEmpty) return '';
    
    // Если заголовок содержит "12 месяцев", проверяем реальный возраст ребенка
    if (originalTitle.contains('12 месяцев')) {
      final child = userStore.selectedChild;
      if (child?.birthDate != null) {
        final now = DateTime.now();
        final birthDate = child!.birthDate!.toLocal();
        final difference = now.difference(birthDate);
        
        final months = (difference.inDays / 30).floor();
        final days = difference.inDays - (months * 30);
        
        // Если ребенку меньше 1 месяца, показываем возраст в неделях
        if (months < 1) {
          final weeks = difference.inDays ~/ 7;
          
          if (weeks > 0) {
            // Если 4 недели или больше, показываем как месяцы
            if (weeks >= 4) {
              final monthsFromWeeks = weeks ~/ 4;
              final remainingWeeks = weeks % 4;
              
              if (remainingWeeks > 0) {
                return '$monthsFromWeeks ${monthsFromWeeks == 1 ? 'месяц' : monthsFromWeeks < 5 ? 'месяца' : 'месяцев'} $remainingWeeks ${remainingWeeks == 1 ? 'неделя' : remainingWeeks < 5 ? 'недели' : 'недель'}';
              } else {
                return '$monthsFromWeeks ${monthsFromWeeks == 1 ? 'месяц' : monthsFromWeeks < 5 ? 'месяца' : 'месяцев'}';
              }
            } else {
              return '$weeks ${weeks == 1 ? 'неделя' : weeks < 5 ? 'недели' : 'недель'}';
            }
          } else {
            // Если меньше недели, показываем дни
            final days = difference.inDays;
            return '$days ${days == 1 ? 'день' : days < 5 ? 'дня' : 'дней'}';
          }
        } else {
          // Если ребенку 1 месяц или больше, показываем возраст в месяцах и днях
          return '$months ${months == 1 ? 'месяц' : months < 5 ? 'месяца' : 'месяцев'} $days ${days == 1 ? 'день' : days < 5 ? 'дня' : 'дней'}';
        }
      }
    }
    
    return originalTitle;
  }

  @override
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: [
          t.trackers.feedTableTitles.title1,
          t.trackers.feedTableTitles.title2,
          t.trackers.feedTableTitles.title3,
          t.trackers.feedTableTitles.title4,
        ],
        columnWidths: {
          0: 2,
        },
        rows: rows,
        cellDecoration: CellDecoration(
          headerStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            fontFamily: 'SFProText',
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

    for (var i = 0; i < listData.length; i++) {
      final e = listData[i];
      final items = e.table ?? const <FeedingCellTable>[];
      if (items.isEmpty) continue;

      // Добавляем заголовок месяца/периода с исправленным возрастом
      result.add([
        TableItem(title: _fixTitle(e.title), row: i + 1, column: 1, trailing: null),
        TableItem(title: '', row: i + 1, column: 2, trailing: null),
        TableItem(title: '', row: i + 1, column: 3, trailing: null),
        TableItem(title: '', row: i + 1, column: 4, trailing: null),
      ]);

      // Добавляем строки дней
      for (final tableItem in items) {
        result.add([
          TableItem(title: tableItem.title, row: i + 1, column: 1, trailing: null),
          TableItem(title: tableItem.chest, row: i + 1, column: 2, trailing: null),
          TableItem(title: tableItem.food, row: i + 1, column: 3, trailing: null),
          TableItem(title: tableItem.lure, row: i + 1, column: 4, trailing: null),
        ]);
      }
    }

    return ObservableList.of(result);
  }

  // var data = List.from(e.table!.map((element) {
  //   [
  //     TableItem(
  //         title: element.title,
  //         row: i + 1,
  //         column: 1,
  //         trailing: element.note != null || element.note!.isNotEmpty
  //             ? const NoteIconWidget()
  //             : null),
  //     TableItem(title: element.chest, row: i + 1, column: 2),
  //     TableItem(title: element.food, row: i + 1, column: 3),
  //     TableItem(title: element.lure, row: i + 1, column: 4),
  //   ];
  // })).toList();
  // return data;
  // }));
}
