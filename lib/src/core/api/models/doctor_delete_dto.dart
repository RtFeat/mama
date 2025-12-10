// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'doctor_delete_dto.g.dart';

@JsonSerializable()
class DoctorDeleteDto {
  const DoctorDeleteDto({
    this.id,
  });
  
  factory DoctorDeleteDto.fromJson(Map<String, Object?> json) => _$DoctorDeleteDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$DoctorDeleteDtoToJson(this);
}
