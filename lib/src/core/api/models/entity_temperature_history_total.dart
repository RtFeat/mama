// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_temperature_history.dart';

part 'entity_temperature_history_total.g.dart';

@JsonSerializable()
class EntityTemperatureHistoryTotal {
  const EntityTemperatureHistoryTotal({
    this.temperatureHistory,
    this.timeToMonths,
  });
  
  factory EntityTemperatureHistoryTotal.fromJson(Map<String, Object?> json) => _$EntityTemperatureHistoryTotalFromJson(json);
  
  @JsonKey(name: 'temperature_history')
  final List<EntityTemperatureHistory>? temperatureHistory;
  @JsonKey(name: 'time_to_months')
  final String? timeToMonths;

  Map<String, Object?> toJson() => _$EntityTemperatureHistoryTotalToJson(this);
}
