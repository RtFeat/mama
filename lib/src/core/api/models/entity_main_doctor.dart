// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_main_doctor.g.dart';

@JsonSerializable()
class EntityMainDoctor {
  const EntityMainDoctor({
    this.data,
    this.doctor,
    this.id,
    this.notes,
    this.photo,
  });
  
  factory EntityMainDoctor.fromJson(Map<String, Object?> json) => _$EntityMainDoctorFromJson(json);
  
  final String? data;
  final String? doctor;
  final String? id;
  final String? notes;
  final String? photo;

  Map<String, Object?> toJson() => _$EntityMainDoctorToJson(this);
}
