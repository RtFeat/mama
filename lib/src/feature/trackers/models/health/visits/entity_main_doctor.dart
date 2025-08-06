// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_main_doctor.g.dart';

@JsonSerializable()
class EntityMainDoctor {
  EntityMainDoctor({
    this.date,
    this.doctor,
    this.id,
    this.notes,
    this.photos,
    this.clinic,
    this.isLocal = false,
  });

  factory EntityMainDoctor.fromJson(Map<String, Object?> json) =>
      _$EntityMainDoctorFromJson(json);

  DateTime? date;
  String? doctor;
  String? id;
  String? notes;
  List<String>? photos;
  String? clinic;

  bool isLocal;

  Map<String, Object?> toJson() => _$EntityMainDoctorToJson(this);
}
