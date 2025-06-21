// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sleepcry_insert_cry_dto.g.dart';

@JsonSerializable()
class SleepcryInsertCryDto {
  const SleepcryInsertCryDto({
    this.allCry,
    this.childId,
    this.notes,
    this.timeEnd,
    this.timeToEnd,
    this.timeToStart,
  });
  
  factory SleepcryInsertCryDto.fromJson(Map<String, Object?> json) => _$SleepcryInsertCryDtoFromJson(json);
  
  @JsonKey(name: 'all_cry')
  final String? allCry;
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? notes;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'time_to_start')
  final String? timeToStart;

  Map<String, Object?> toJson() => _$SleepcryInsertCryDtoToJson(this);
}
