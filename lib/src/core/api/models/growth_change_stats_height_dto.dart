// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_height.dart';

part 'growth_change_stats_height_dto.g.dart';

@JsonSerializable()
class GrowthChangeStatsHeightDto {
  const GrowthChangeStatsHeightDto({
    this.stats,
  });
  
  factory GrowthChangeStatsHeightDto.fromJson(Map<String, Object?> json) => _$GrowthChangeStatsHeightDtoFromJson(json);
  
  final EntityHeight? stats;

  Map<String, Object?> toJson() => _$GrowthChangeStatsHeightDtoToJson(this);
}
