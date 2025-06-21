// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_sleep_history.g.dart';

@JsonSerializable()
class EntitySleepHistory {
  const EntitySleepHistory({
    this.notes,
    this.timeAll,
    this.timeEnd,
    this.timeStart,
  });
  
  factory EntitySleepHistory.fromJson(Map<String, Object?> json) => _$EntitySleepHistoryFromJson(json);
  
  final String? notes;
  @JsonKey(name: 'time_all')
  final String? timeAll;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_start')
  final String? timeStart;

  Map<String, Object?> toJson() => _$EntitySleepHistoryToJson(this);
}
