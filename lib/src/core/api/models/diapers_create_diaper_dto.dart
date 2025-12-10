// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'diapers_create_diaper_dto.g.dart';

@JsonSerializable()
class DiapersCreateDiaperDto {
  const DiapersCreateDiaperDto({
    this.childId,
    this.howMuch,
    this.notes,
    this.timeToEnd,
    this.typeOfDiapers,
  });
  
  factory DiapersCreateDiaperDto.fromJson(Map<String, Object?> json) => _$DiapersCreateDiaperDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'how_much')
  final String? howMuch;
  final String? notes;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'type_of_diapers')
  final String? typeOfDiapers;

  Map<String, Object?> toJson() => _$DiapersCreateDiaperDtoToJson(this);
}
