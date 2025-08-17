// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_temperature_history.g.dart';

@JsonSerializable()
class EntityTemperatureHistory {
  const EntityTemperatureHistory({
    this.isBad,
    this.notes,
    this.temperatures,
    this.time,
  });

  factory EntityTemperatureHistory.fromJson(Map<String, Object?> json) =>
      _$EntityTemperatureHistoryFromJson(json);

  @JsonKey(name: 'is_bad')
  final bool? isBad;
  final String? notes;
  final String? temperatures;
  final String? time;

  Map<String, Object?> toJson() => _$EntityTemperatureHistoryToJson(this);
}
