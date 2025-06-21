// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_delete_cons_doctor.g.dart';

@JsonSerializable()
class HealthDeleteConsDoctor {
  const HealthDeleteConsDoctor({
    required this.id,
  });
  
  factory HealthDeleteConsDoctor.fromJson(Map<String, Object?> json) => _$HealthDeleteConsDoctorFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$HealthDeleteConsDoctorToJson(this);
}
