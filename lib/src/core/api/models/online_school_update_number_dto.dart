// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'online_school_update_number_dto.g.dart';

@JsonSerializable()
class OnlineSchoolUpdateNumberDto {
  const OnlineSchoolUpdateNumberDto({
    this.numberNew,
    this.numberOld,
    this.onlineSchoolId,
  });
  
  factory OnlineSchoolUpdateNumberDto.fromJson(Map<String, Object?> json) => _$OnlineSchoolUpdateNumberDtoFromJson(json);
  
  @JsonKey(name: 'number_new')
  final String? numberNew;
  @JsonKey(name: 'number_old')
  final String? numberOld;
  @JsonKey(name: 'online_school_id')
  final String? onlineSchoolId;

  Map<String, Object?> toJson() => _$OnlineSchoolUpdateNumberDtoToJson(this);
}
