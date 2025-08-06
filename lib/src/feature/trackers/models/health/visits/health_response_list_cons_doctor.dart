// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_main_doctor.dart';

part 'health_response_list_cons_doctor.g.dart';

@JsonSerializable()
class HealthResponseListConsDoctor {
  const HealthResponseListConsDoctor({
    this.list,
  });

  factory HealthResponseListConsDoctor.fromJson(Map<String, Object?> json) =>
      _$HealthResponseListConsDoctorFromJson(json);

  final List<EntityMainDoctor>? list;

  Map<String, Object?> toJson() => _$HealthResponseListConsDoctorToJson(this);
}
