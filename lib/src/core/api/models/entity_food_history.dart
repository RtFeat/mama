// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_food_history.g.dart';

@JsonSerializable()
class EntityFoodHistory {
  const EntityFoodHistory({
    this.chest,
    this.mixture,
    this.notes,
    this.time,
    this.total,
  });
  
  factory EntityFoodHistory.fromJson(Map<String, Object?> json) => _$EntityFoodHistoryFromJson(json);
  
  final int? chest;
  final int? mixture;
  final String? notes;
  final String? time;
  final int? total;

  Map<String, Object?> toJson() => _$EntityFoodHistoryToJson(this);
}
