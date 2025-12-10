// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_delete_circle_dto.g.dart';

@JsonSerializable()
class GrowthDeleteCircleDto {
  const GrowthDeleteCircleDto({
    this.id,
  });
  
  factory GrowthDeleteCircleDto.fromJson(Map<String, Object?> json) => _$GrowthDeleteCircleDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$GrowthDeleteCircleDtoToJson(this);
}
