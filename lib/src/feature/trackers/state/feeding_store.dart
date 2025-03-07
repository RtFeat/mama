import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/models/feeding_cell.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'feeding_store.g.dart';

class FeedingStore extends _FeedingStore with _$FeedingStore {
  FeedingStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _FeedingStore extends TableStore<FeedingCell> with Store {
  _FeedingStore({
    required super.apiClient,
    required super.faker,
  }) : super(
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

            return data;
          },
        );

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
  ObservableList<List<TableItem>> get rows =>
      ObservableList.of(listData.mapIndexed((i, e) {
        return [
          TableItem(
              title: e.title,
              row: i + 1,
              column: 1,
              trailing: null,
              isHorizontalHeader: true),
          TableItem(title: '', row: i + 1, column: 2, isHorizontalHeader: true),
          TableItem(title: '', row: i + 1, column: 3, isHorizontalHeader: true),
          TableItem(title: '', row: i + 1, column: 4, isHorizontalHeader: true),
          for (int j = 0; j < e.table!.length; j++) ...[
            TableItem(
                title: e.table![j].title,
                row: i + 1,
                column: 1,
                trailing: null),
            TableItem(title: e.table![j].chest, row: i + 1, column: 2),
            TableItem(title: e.table![j].food, row: i + 1, column: 3),
            TableItem(title: e.table![j].lure, row: i + 1, column: 4),
          ]
        ];
      }));
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
