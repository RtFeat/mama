// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_sleep_cry_total.dart';

part 'sleepcry_response_history_table.g.dart';

@JsonSerializable()
class SleepcryResponseHistoryTable {
  const SleepcryResponseHistoryTable({
    this.list,
  });
  
  factory SleepcryResponseHistoryTable.fromJson(Map<String, Object?> json) => _$SleepcryResponseHistoryTableFromJson(json);
  
  final List<EntityTableSleepCryTotal>? list;

  Map<String, Object?> toJson() => _$SleepcryResponseHistoryTableToJson(this);
}
