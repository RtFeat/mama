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
  });
}

abstract class _EvolutionTableStore extends TableStore<EntityTable> with Store {
  _EvolutionTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
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
        );
  final RestClient restClient;

  @observable
  String sortOrder = 'new'; // 'new' or 'old'

  @observable
  WeightUnit weightUnit = WeightUnit.kg; // 'kg' or 'g'

  @observable
  CircleUnit circleUnit = CircleUnit.cm;

  @action
  void setSortOrder(int index) {
    sortOrder = index == 0 ? 'new' : 'old';
  }

  @action
  void setWeightUnit(WeightUnit unit) {
    weightUnit = unit;
  }

  @action
  void setCircleUnit(CircleUnit unit) {
    circleUnit = unit;
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
          title: entity.week,
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
