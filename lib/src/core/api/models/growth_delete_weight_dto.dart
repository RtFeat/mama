// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_delete_weight_dto.g.dart';

@JsonSerializable()
class GrowthDeleteWeightDto {
  const GrowthDeleteWeightDto({
    this.id,
  });
  
  factory GrowthDeleteWeightDto.fromJson(Map<String, Object?> json) => _$GrowthDeleteWeightDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$GrowthDeleteWeightDtoToJson(this);
}
