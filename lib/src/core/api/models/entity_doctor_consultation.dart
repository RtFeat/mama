// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_doctor_consultation.g.dart';

@JsonSerializable()
class EntityDoctorConsultation {
  const EntityDoctorConsultation({
    this.accountId,
    this.avatar,
    this.createdAt,
    this.firstName,
    this.id,
    this.isConsultation,
    this.lastName,
    this.profession,
    this.updatedAt,
  });
  
  factory EntityDoctorConsultation.fromJson(Map<String, Object?> json) => _$EntityDoctorConsultationFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  final String? avatar;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final String? id;
  @JsonKey(name: 'is_consultation')
  final bool? isConsultation;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? profession;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityDoctorConsultationToJson(this);
}
