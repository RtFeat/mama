// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'online_school_update_dto.g.dart';

@JsonSerializable()
class OnlineSchoolUpdateDto {
  const OnlineSchoolUpdateDto({
    this.email,
    this.info,
    this.name,
  });
  
  factory OnlineSchoolUpdateDto.fromJson(Map<String, Object?> json) => _$OnlineSchoolUpdateDtoFromJson(json);
  
  final String? email;
  final String? info;
  final String? name;

  Map<String, Object?> toJson() => _$OnlineSchoolUpdateDtoToJson(this);
}
