// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_cry_and_sleep.dart';

part 'sleepcry_response_history_table_period.g.dart';

@JsonSerializable()
class SleepcryResponseHistoryTablePeriod {
  const SleepcryResponseHistoryTablePeriod({
    this.list,
  });
  
  factory SleepcryResponseHistoryTablePeriod.fromJson(Map<String, Object?> json) => _$SleepcryResponseHistoryTablePeriodFromJson(json);
  
  final EntityCryAndSleep? list;

  Map<String, Object?> toJson() => _$SleepcryResponseHistoryTablePeriodToJson(this);
}
