// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_table_sleep_cry_total.g.dart';

@JsonSerializable()
class EntityTableSleepCryTotal {
  const EntityTableSleepCryTotal({
    this.cry,
    this.notes,
    this.sleep,
    this.time,
  });
  
  factory EntityTableSleepCryTotal.fromJson(Map<String, Object?> json) => _$EntityTableSleepCryTotalFromJson(json);
  
  final String? cry;
  final String? notes;
  final String? sleep;
  final String? time;

  Map<String, Object?> toJson() => _$EntityTableSleepCryTotalToJson(this);
}
