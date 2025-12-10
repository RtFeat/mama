// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_pumping_history.dart';

part 'entity_pumping_history_total.g.dart';

@JsonSerializable()
class EntityPumpingHistoryTotal {
  const EntityPumpingHistoryTotal({
    this.pumpingHistory,
    this.timeToEnd,
    this.timeToEndTotal,
    this.totalLeft,
    this.totalRight,
    this.totalTotal,
  });
  
  factory EntityPumpingHistoryTotal.fromJson(Map<String, Object?> json) => _$EntityPumpingHistoryTotalFromJson(json);
  
  @JsonKey(name: 'pumping_history')
  final List<EntityPumpingHistory>? pumpingHistory;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;
  @JsonKey(name: 'total_left')
  final int? totalLeft;
  @JsonKey(name: 'total_right')
  final int? totalRight;
  @JsonKey(name: 'total_total')
  final int? totalTotal;

  Map<String, Object?> toJson() => _$EntityPumpingHistoryTotalToJson(this);
}
