// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_doctor_base.g.dart';

@JsonSerializable()
class EntityDoctorBase {
  const EntityDoctorBase({
    this.accountId,
    this.createdAt,
    this.id,
    this.isConsultation,
    this.profession,
    this.updatedAt,
  });
  
  factory EntityDoctorBase.fromJson(Map<String, Object?> json) => _$EntityDoctorBaseFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  @JsonKey(name: 'is_consultation')
  final bool? isConsultation;
  final String? profession;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityDoctorBaseToJson(this);
}
