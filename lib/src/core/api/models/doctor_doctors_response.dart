// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_doctor_response.dart';

part 'doctor_doctors_response.g.dart';

@JsonSerializable()
class DoctorDoctorsResponse {
  const DoctorDoctorsResponse({
    this.doctors,
  });
  
  factory DoctorDoctorsResponse.fromJson(Map<String, Object?> json) => _$DoctorDoctorsResponseFromJson(json);
  
  final List<EntityDoctorResponse>? doctors;

  Map<String, Object?> toJson() => _$DoctorDoctorsResponseToJson(this);
}
