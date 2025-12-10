// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_sleep_history.dart';

part 'entity_sleep_history_total.g.dart';

@JsonSerializable()
class EntitySleepHistoryTotal {
  const EntitySleepHistoryTotal({
    this.months,
    this.sleepTotal,
    this.time,
    this.timeToEndTotal,
  });
  
  factory EntitySleepHistoryTotal.fromJson(Map<String, Object?> json) => _$EntitySleepHistoryTotalFromJson(json);
  
  final String? months;
  @JsonKey(name: 'sleep_total')
  final List<EntitySleepHistory>? sleepTotal;
  final String? time;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;

  Map<String, Object?> toJson() => _$EntitySleepHistoryTotalToJson(this);
}
