// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_sleep.dart';

part 'sleepcry_get_sleep_response.g.dart';

@JsonSerializable()
class SleepcryGetSleepResponse {
  const SleepcryGetSleepResponse({
    this.list,
  });
  
  factory SleepcryGetSleepResponse.fromJson(Map<String, Object?> json) => _$SleepcryGetSleepResponseFromJson(json);
  
  final List<EntitySleep>? list;

  Map<String, Object?> toJson() => _$SleepcryGetSleepResponseToJson(this);
}
