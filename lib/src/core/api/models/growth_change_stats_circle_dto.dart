// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_circle.dart';

part 'growth_change_stats_circle_dto.g.dart';

@JsonSerializable()
class GrowthChangeStatsCircleDto {
  const GrowthChangeStatsCircleDto({
    this.stats,
  });
  
  factory GrowthChangeStatsCircleDto.fromJson(Map<String, Object?> json) => _$GrowthChangeStatsCircleDtoFromJson(json);
  
  final EntityCircle? stats;

  Map<String, Object?> toJson() => _$GrowthChangeStatsCircleDtoToJson(this);
}
