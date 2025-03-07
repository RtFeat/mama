import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'sleep_cry_store.g.dart';

class SleepCryStore extends _SleepCryStore with _$SleepCryStore {
  SleepCryStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _SleepCryStore extends TableStore<SleepCryCell> with Store {
  _SleepCryStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return SleepCryCell(
              title: faker.lorem.word(),
              sleep:
                  '${faker.datatype.number(max: 10).toString()} ч ${faker.datatype.number(max: 60).toString()} м',
              cry:
                  '${faker.datatype.number(max: 10).toString()} ч ${faker.datatype.number(max: 60).toString()} м',
            );
          },
          basePath: Endpoint().sleepCryTable,
          fetchFunction: (params, path) =>
              apiClient.get('$path/new', queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => SleepCryCell.fromJson(e))
                .toList();

            return data;
          },
        );

  @override
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: [
          t.trackers.date.title,
          t.trackers.sleep,
          t.trackers.crying,
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
              trailing: e.note != null && e.note!.isNotEmpty
                  ? const NoteIconWidget()
                  : null),
          TableItem(title: e.sleep, row: i + 1, column: 2),
          TableItem(title: e.cry, row: i + 1, column: 3),
        ];
      }));
}
