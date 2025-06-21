// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_temperature_history_total.dart';

part 'health_response_history_temperature.g.dart';

@JsonSerializable()
class HealthResponseHistoryTemperature {
  const HealthResponseHistoryTemperature({
    this.list,
  });
  
  factory HealthResponseHistoryTemperature.fromJson(Map<String, Object?> json) => _$HealthResponseHistoryTemperatureFromJson(json);
  
  final List<EntityTemperatureHistoryTotal>? list;

  Map<String, Object?> toJson() => _$HealthResponseHistoryTemperatureToJson(this);
}
