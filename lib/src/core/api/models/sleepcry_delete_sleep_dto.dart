// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sleepcry_delete_sleep_dto.g.dart';

@JsonSerializable()
class SleepcryDeleteSleepDto {
  const SleepcryDeleteSleepDto({
    this.id,
  });
  
  factory SleepcryDeleteSleepDto.fromJson(Map<String, Object?> json) => _$SleepcryDeleteSleepDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$SleepcryDeleteSleepDtoToJson(this);
}
