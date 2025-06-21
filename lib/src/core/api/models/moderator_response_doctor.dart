// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_doctor_response.dart';

part 'moderator_response_doctor.g.dart';

@JsonSerializable()
class ModeratorResponseDoctor {
  const ModeratorResponseDoctor({
    this.doctor,
  });
  
  factory ModeratorResponseDoctor.fromJson(Map<String, Object?> json) => _$ModeratorResponseDoctorFromJson(json);
  
  final EntityDoctorResponse? doctor;

  Map<String, Object?> toJson() => _$ModeratorResponseDoctorToJson(this);
}
