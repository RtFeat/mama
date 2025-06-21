// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_get_weight.g.dart';

@JsonSerializable()
class EntityGetWeight {
  const EntityGetWeight({
    this.getWeights,
    this.isNormal,
    this.median,
    this.normal,
    this.notes,
    this.weeks,
    this.weight,
  });
  
  factory EntityGetWeight.fromJson(Map<String, Object?> json) => _$EntityGetWeightFromJson(json);
  
  @JsonKey(name: 'get_weights')
  final String? getWeights;
  @JsonKey(name: 'is_normal')
  final String? isNormal;
  final String? median;
  final String? normal;
  final String? notes;
  final String? weeks;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityGetWeightToJson(this);
}
