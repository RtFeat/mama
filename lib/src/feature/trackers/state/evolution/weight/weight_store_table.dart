import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'weight_store_table.g.dart';

class WeightTableStore extends _WeightTableStore with _$WeightTableStore {
  WeightTableStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _WeightTableStore extends TableStore<EntityHistoryWeight>
    with Store {
  _WeightTableStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return EntityHistoryWeight();
          },
          basePath: 'growth/weight/history',
          fetchFunction: (params, path) =>
              apiClient.get(path, queryParams: params),
          pageSize: 15,
          transformer: (raw) {
            final data = GrowthResponseHistoryWeight.fromJson(raw);
            return {
              'main': data.list ?? <EntityHistoryWeight>[],
            };
          },
        );

  @override
  TableData get tableData => TableData(
      headerTitle: '',
      columnHeaders: [
        'Дата',
        '',
        'Неделя',
        'Вес',
      ],
      columnWidths: {
        0: 3,
        1: 2,
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
    final List<List<TableItem>> result = [];
    for (final entity in listData) {
      // final temp = tempHistory[colIdx];
      final bool hasNote = entity.notes != null && entity.notes!.isNotEmpty;

      final bool isBad = entity.normal == 'Вне нормы';
      final bool isNormal = entity.normal == 'Граница нормы';

      final decoration = (isBad || isNormal)
          ? CellDecoration(
              color: isBad
                  ? AppColors.yellowBackgroundColor
                  : AppColors.greenLighterBackgroundColor,
              radius: 8,
            )
          : null;

      result.add([
        TableItem(
          title: entity.data.toString(),
          row: result.length + 1,
          column: 1,
          isHide: false,
          decoration: decoration,
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
          title: entity.normal,
          row: result.length + 1,
          column: 2,
          trailing: SizedBox(
            height: 20,
          ),
          decoration: decoration?.copyWith(
              textStyle: AppTextStyles.f10w700.copyWith(
            color: isBad
                ? AppColors.orangeTextColor
                : AppColors.greenLightTextColor,
          )),
        ),
        TableItem(
          title: entity.weeks.toString(),
          row: result.length + 1,
          column: 2,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        TableItem(
          title: entity.weight,
          row: result.length + 1,
          column: 3,
          decoration: decoration,
          mainAxisAlignment: MainAxisAlignment.center,
          // decoration: (temp.isBad ?? false)
          //     ? CellDecoration(
          //         color: AppColors.yellowBackgroundColor,
          //         radius: 8,
          //         textStyle: _cellTextStyle,
          //       )
          //     : null,
        ),
      ]);
    }
    return ObservableList.of(result);
  }
}
