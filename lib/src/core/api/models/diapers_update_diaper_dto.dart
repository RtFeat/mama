// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'diapers_update_diaper_dto.g.dart';

@JsonSerializable()
class DiapersUpdateDiaperDto {
  const DiapersUpdateDiaperDto({
    this.howMuch,
    this.id,
    this.notes,
    this.timeToEnd,
    this.typeOfDiapers,
  });
  
  factory DiapersUpdateDiaperDto.fromJson(Map<String, Object?> json) => _$DiapersUpdateDiaperDtoFromJson(json);
  
  @JsonKey(name: 'how_much')
  final String? howMuch;
  final String? id;
  final String? notes;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'type_of_diapers')
  final String? typeOfDiapers;

  Map<String, Object?> toJson() => _$DiapersUpdateDiaperDtoToJson(this);
}
