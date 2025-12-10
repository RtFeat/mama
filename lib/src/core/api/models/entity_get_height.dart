// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_get_height.g.dart';

@JsonSerializable()
class EntityGetHeight {
  const EntityGetHeight({
    this.getHeights,
    this.isNormal,
    this.median,
    this.normal,
    this.notes,
    this.weeks,
    this.weight,
  });
  
  factory EntityGetHeight.fromJson(Map<String, Object?> json) => _$EntityGetHeightFromJson(json);
  
  @JsonKey(name: 'get_heights')
  final String? getHeights;
  @JsonKey(name: 'is_normal')
  final String? isNormal;
  final String? median;
  final String? normal;
  final String? notes;
  final String? weeks;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityGetHeightToJson(this);
}
