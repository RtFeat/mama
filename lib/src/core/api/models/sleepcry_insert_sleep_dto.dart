// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sleepcry_insert_sleep_dto.g.dart';

@JsonSerializable()
class SleepcryInsertSleepDto {
  const SleepcryInsertSleepDto({
    this.allSleep,
    this.childId,
    this.notes,
    this.timeEnd,
    this.timeToEnd,
    this.timeToStart,
  });
  
  factory SleepcryInsertSleepDto.fromJson(Map<String, Object?> json) => _$SleepcryInsertSleepDtoFromJson(json);
  
  @JsonKey(name: 'all_sleep')
  final String? allSleep;
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? notes;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'time_to_start')
  final String? timeToStart;

  Map<String, Object?> toJson() => _$SleepcryInsertSleepDtoToJson(this);
}
