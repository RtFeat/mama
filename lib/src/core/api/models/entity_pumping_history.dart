// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_pumping_history.g.dart';

@JsonSerializable()
class EntityPumpingHistory {
  const EntityPumpingHistory({
    this.left,
    this.notes,
    this.right,
    this.time,
    this.total,
  });
  
  factory EntityPumpingHistory.fromJson(Map<String, Object?> json) => _$EntityPumpingHistoryFromJson(json);
  
  final int? left;
  final String? notes;
  final int? right;
  final String? time;
  final int? total;

  Map<String, Object?> toJson() => _$EntityPumpingHistoryToJson(this);
}
