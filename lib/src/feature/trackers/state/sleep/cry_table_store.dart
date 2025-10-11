import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';
import 'package:uuid/uuid.dart';
import 'package:mama/src/core/api/models/sleepcry_get_cry_response.dart';

class CryTableStore extends _CryTableStore {
  CryTableStore({
    required super.apiClient,
    required super.faker,
    required super.restClient,
  });
}

abstract class _CryTableStore extends TableStore<EntityCry> with Store {
  _CryTableStore({
    required super.apiClient,
    required super.faker,
    required this.restClient,
  }) : super(
          testDataGenerator: () => EntityCry(),
          basePath: 'sleep_cry/cry/get',
          fetchFunction: (params, path) => apiClient.get(path, queryParams: params),
          pageSize: 150,
          transformer: (raw) {
            final data = SleepcryGetCryResponse.fromJson(raw);
            return {'main': data.list ?? <EntityCry>[]};
          },
        );

  final RestClient restClient;

  // Table for Skit (not used directly in this UI but must be implemented)
  @override
  TableData get tableData => TableData(
        headerTitle: '',
        columnHeaders: ['Дата', 'Начало', 'Окончание', 'Время'],
        columnWidths: {
          0: 2,
          1: 1,
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
        ),
      );

  @override
  ObservableList<List<TableItem>> get rows {
    final List<List<TableItem>> result = [];
    for (final e in listData) {
      final start = DateTime.tryParse(e.timeToStart ?? '') ?? DateTime.now();
      DateTime end = DateTime.tryParse(e.timeEnd ?? '') ?? start;
      if (end.isBefore(start)) {
        end = end.add(const Duration(days: 1));
      }
      final dur = end.difference(start).inMinutes;
      result.add([
        TableItem(title: DateFormat('dd MMMM').format(start), row: result.length + 1, column: 1),
        TableItem(title: DateFormat('HH:mm').format(start), row: result.length + 1, column: 2),
        TableItem(title: DateFormat('HH:mm').format(end), row: result.length + 1, column: 3),
        TableItem(title: _minutesToHhMm(dur), row: result.length + 1, column: 4),
      ]);
    }
    return ObservableList.of(result);
  }

  static String _minutesToHhMm(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}м';
    return '${h}ч ${m}м';
  }

  static DateTime _parseDateStatic(String? date) {
    if (date == null) return DateTime(2024, 1, 1); // Стабильное значение
    try {
      if (date.contains('T')) return DateTime.parse(date);
      if (date.contains(' ')) return DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      return DateFormat('yyyy-MM-dd').parse(date);
    } catch (_) {
      return DateTime(2024, 1, 1); // Стабильное значение
    }
  }

  static DateTime _parseTimeStatic(String? t) {
    if (t == null) return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    try {
      return DateFormat('HH:mm').parse(t);
    } catch (_) {
      return DateTime(2024, 1, 1, 12, 0); // Стабильное значение
    }
  }
}
