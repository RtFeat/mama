// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'doctor_update_dto.g.dart';

@JsonSerializable()
class DoctorUpdateDto {
  const DoctorUpdateDto({
    this.email,
    this.firstName,
    this.gender,
    this.info,
    this.lastName,
    this.profession,
    this.secondName,
  });
  
  factory DoctorUpdateDto.fromJson(Map<String, Object?> json) => _$DoctorUpdateDtoFromJson(json);
  
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final String? gender;
  final String? info;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? profession;
  @JsonKey(name: 'second_name')
  final String? secondName;

  Map<String, Object?> toJson() => _$DoctorUpdateDtoToJson(this);
}
