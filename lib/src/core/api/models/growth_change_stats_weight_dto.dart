// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_weight.dart';

part 'growth_change_stats_weight_dto.g.dart';

@JsonSerializable()
class GrowthChangeStatsWeightDto {
  const GrowthChangeStatsWeightDto({
    this.stats,
  });
  
  factory GrowthChangeStatsWeightDto.fromJson(Map<String, Object?> json) => _$GrowthChangeStatsWeightDtoFromJson(json);
  
  final EntityWeight? stats;

  Map<String, Object?> toJson() => _$GrowthChangeStatsWeightDtoToJson(this);
}
