// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_food.g.dart';

@JsonSerializable()
class EntityFood {
  const EntityFood({
    this.chest,
    this.childId,
    this.id,
    this.mixture,
    this.notes,
    this.timeToEnd,
  });
  
  factory EntityFood.fromJson(Map<String, Object?> json) => _$EntityFoodFromJson(json);
  
  final int? chest;
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? id;
  final int? mixture;
  final String? notes;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;

  Map<String, Object?> toJson() => _$EntityFoodToJson(this);
}
