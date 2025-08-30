// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_delete_height_dto.g.dart';

@JsonSerializable()
class GrowthDeleteHeightDto {
  const GrowthDeleteHeightDto({
    this.id,
  });
  
  factory GrowthDeleteHeightDto.fromJson(Map<String, Object?> json) => _$GrowthDeleteHeightDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$GrowthDeleteHeightDtoToJson(this);
}
