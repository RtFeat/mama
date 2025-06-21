// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_insert_height_dto.g.dart';

@JsonSerializable()
class GrowthInsertHeightDto {
  const GrowthInsertHeightDto({
    this.childId,
    this.createdAt,
    this.height,
    this.notes,
  });
  
  factory GrowthInsertHeightDto.fromJson(Map<String, Object?> json) => _$GrowthInsertHeightDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? height;
  final String? notes;

  Map<String, Object?> toJson() => _$GrowthInsertHeightDtoToJson(this);
}
