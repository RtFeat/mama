// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_insert_weight_dto.g.dart';

@JsonSerializable()
class GrowthInsertWeightDto {
  const GrowthInsertWeightDto({
    this.childId,
    this.createdAt,
    this.notes,
    this.weight,
  });
  
  factory GrowthInsertWeightDto.fromJson(Map<String, Object?> json) => _$GrowthInsertWeightDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? notes;
  final String? weight;

  Map<String, Object?> toJson() => _$GrowthInsertWeightDtoToJson(this);
}
