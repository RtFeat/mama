// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_food_history.dart';

part 'entity_food_history_total.g.dart';

@JsonSerializable()
class EntityFoodHistoryTotal {
  const EntityFoodHistoryTotal({
    this.foodHistory,
    this.object0,
    this.timeToEndTotal,
    this.timeToEnd,
    this.totalChest,
    this.totalMixture,
    this.totalTotal,
  });

  factory EntityFoodHistoryTotal.fromJson(Map<String, Object?> json) =>
      _$EntityFoodHistoryTotalFromJson(json);

  @JsonKey(name: 'food_history')
  final List<EntityFoodHistory>? foodHistory;

  /// Incorrect name has been replaced. Original name: `time_to_end_don't_use'`.
  @JsonKey(name: "time_to_end_don't_use")
  final String? object0;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;
  @JsonKey(name: 'TimeToEnd')
  final String? timeToEnd;
  @JsonKey(name: 'total_chest')
  final int? totalChest;
  @JsonKey(name: 'total_mixture')
  final int? totalMixture;
  @JsonKey(name: 'total_total')
  final int? totalTotal;

  Map<String, Object?> toJson() => _$EntityFoodHistoryTotalToJson(this);
}
