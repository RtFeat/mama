// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_chest_history.dart';

part 'entity_chest_history_total.g.dart';

@JsonSerializable()
class EntityChestHistoryTotal {
  const EntityChestHistoryTotal({
    this.chestHistory,
    this.timeToEndDontUse,
    this.timeToEndTotal,
    this.totalLeft,
    this.totalMinutes,
    this.totalRight,
  });
  
  factory EntityChestHistoryTotal.fromJson(Map<String, Object?> json) => _$EntityChestHistoryTotalFromJson(json);
  
  @JsonKey(name: 'chest_history')
  final List<EntityChestHistory>? chestHistory;
  @JsonKey(name: 'time_to_end_dont_use')
  final String? timeToEndDontUse;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;
  @JsonKey(name: 'total_left')
  final int? totalLeft;
  @JsonKey(name: 'total_minutes')
  final int? totalMinutes;
  @JsonKey(name: 'total_right')
  final int? totalRight;

  Map<String, Object?> toJson() => _$EntityChestHistoryTotalToJson(this);
}
