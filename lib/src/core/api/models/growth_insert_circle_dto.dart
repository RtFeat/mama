// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_insert_circle_dto.g.dart';

@JsonSerializable()
class GrowthInsertCircleDto {
  const GrowthInsertCircleDto({
    this.childId,
    this.circle,
    this.createdAt,
    this.notes,
  });
  
  factory GrowthInsertCircleDto.fromJson(Map<String, Object?> json) => _$GrowthInsertCircleDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? circle;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? notes;

  Map<String, Object?> toJson() => _$GrowthInsertCircleDtoToJson(this);
}
