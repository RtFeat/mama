// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'package:mobx/mobx.dart';
import 'entity_temperature_history.dart';

part 'entity_temperature_history_total.g.dart';

@JsonSerializable()
class EntityTemperatureHistoryTotal extends _EntityTemperatureHistoryTotal
    with _$EntityTemperatureHistoryTotal {
  EntityTemperatureHistoryTotal({
    super.temperatureHistory,
    this.title,
  });

  factory EntityTemperatureHistoryTotal.fromJson(Map<String, Object?> json) =>
      _$EntityTemperatureHistoryTotalFromJson(json);

  @JsonKey(name: 'time_to_months')
  final String? title;

  Map<String, Object?> toJson() => _$EntityTemperatureHistoryTotalToJson(this);
}

abstract class _EntityTemperatureHistoryTotal with Store {
  _EntityTemperatureHistoryTotal({
    this.temperatureHistory,
  });

  @JsonKey(name: 'temperature_history')
  @observable
  List<EntityTemperatureHistory>? temperatureHistory;
}
