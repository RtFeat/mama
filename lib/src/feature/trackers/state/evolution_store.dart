// ignore_for_file: unnecessary_string_interpolations

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'evolution_store.g.dart';

class EvolutionStore extends _EvolutionStore with _$EvolutionStore {
  EvolutionStore({
    required super.apiClient,
    required super.faker,
  });
}

abstract class _EvolutionStore extends TableStore<EvolutionCell> with Store {
  _EvolutionStore({
    required super.apiClient,
    required super.faker,
  }) : super(
          pageSize: 50,
          testDataGenerator: () {
            return EvolutionCell(
              title: '${faker.datatype.number(max: 30).toString()} сентября',
              week: faker.datatype.number(max: 17).toString(),
              weight:
                  '${faker.datatype.number(max: 10).toString()},${faker.datatype.number(max: 9).toString()}',
              height: '${faker.datatype.number(max: 110).toString()}',
              circle:
                  '${faker.datatype.number(max: 10).toString()},${faker.datatype.number(max: 9).toString()}',
            );
          },
          basePath: Endpoint().evolutionTable,
          fetchFunction: (params, path) =>
              apiClient.get('$path/new', queryParams: params),
          transformer: (raw) {
            final data = List.from(raw['list'] ?? [])
                .map((e) => EvolutionCell.fromJson(e))
                .toList();

            // return data;

            return {
              'main': data,
            };
          },
        );

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
          TableItem(title: e.week, row: i + 1, column: 2),
          TableItem(title: e.weight, row: i + 1, column: 3),
          TableItem(title: e.height, row: i + 1, column: 4),
          TableItem(title: e.circle, row: i + 1, column: 5),
        ];
      }));
}
