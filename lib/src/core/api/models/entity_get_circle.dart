// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_get_circle.g.dart';

@JsonSerializable()
class EntityGetCircle {
  const EntityGetCircle({
    this.circle,
    this.getCircle,
    this.isNormal,
    this.median,
    this.normal,
    this.notes,
    this.weeks,
  });
  
  factory EntityGetCircle.fromJson(Map<String, Object?> json) => _$EntityGetCircleFromJson(json);
  
  final String? circle;
  @JsonKey(name: 'get_circle')
  final String? getCircle;
  @JsonKey(name: 'is_normal')
  final String? isNormal;
  final String? median;
  final String? normal;
  final String? notes;
  final String? weeks;

  Map<String, Object?> toJson() => _$EntityGetCircleToJson(this);
}
