// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_sleep_history_total.dart';

part 'sleepcry_response_history_sleep.g.dart';

@JsonSerializable()
class SleepcryResponseHistorySleep {
  const SleepcryResponseHistorySleep({
    this.list,
  });
  
  factory SleepcryResponseHistorySleep.fromJson(Map<String, Object?> json) => _$SleepcryResponseHistorySleepFromJson(json);
  
  final List<EntitySleepHistoryTotal>? list;

  Map<String, Object?> toJson() => _$SleepcryResponseHistorySleepToJson(this);
}
