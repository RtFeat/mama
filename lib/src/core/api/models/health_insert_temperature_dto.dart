// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_insert_temperature_dto.g.dart';

@JsonSerializable()
class HealthInsertTemperatureDto {
  const HealthInsertTemperatureDto({
    this.childId,
    this.isBad,
    this.notes,
    this.temperature,
    this.time,
  });
  
  factory HealthInsertTemperatureDto.fromJson(Map<String, Object?> json) => _$HealthInsertTemperatureDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'is_bad')
  final bool? isBad;
  final String? notes;
  final String? temperature;
  final String? time;

  Map<String, Object?> toJson() => _$HealthInsertTemperatureDtoToJson(this);
}
