// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_doctor_response.dart';

part 'doctor_doctor_response.g.dart';

@JsonSerializable()
class DoctorDoctorResponse {
  const DoctorDoctorResponse({
    this.doctor,
  });
  
  factory DoctorDoctorResponse.fromJson(Map<String, Object?> json) => _$DoctorDoctorResponseFromJson(json);
  
  final EntityDoctorResponse? doctor;

  Map<String, Object?> toJson() => _$DoctorDoctorResponseToJson(this);
}
