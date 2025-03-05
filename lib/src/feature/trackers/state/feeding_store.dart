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
  });
}

abstract class _FeedingStore extends TableStore<FeedingCell> with Store {
  _FeedingStore({
    required super.apiClient,
  }) : super(
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
              trailing: e.note != null || e.note!.isNotEmpty
                  ? const NoteIconWidget()
                  : null),
          TableItem(title: e.chest, row: i + 1, column: 2),
          TableItem(title: e.food, row: i + 1, column: 2),
          TableItem(title: e.lure, row: i + 1, column: 3),
        ];
      }));
}
