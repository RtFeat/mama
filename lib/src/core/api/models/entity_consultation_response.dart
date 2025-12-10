// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_doctor_consultation.dart';

part 'entity_consultation_response.g.dart';

@JsonSerializable()
class EntityConsultationResponse {
  const EntityConsultationResponse({
    this.account,
    this.comment,
    this.createdAt,
    this.doctor,
    this.id,
    this.status,
    this.timeBegin,
    this.timeEnd,
    this.type,
  });
  
  factory EntityConsultationResponse.fromJson(Map<String, Object?> json) => _$EntityConsultationResponseFromJson(json);
  
  final EntityAccount? account;
  final String? comment;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final EntityDoctorConsultation? doctor;
  final String? id;
  final String? status;
  @JsonKey(name: 'time_begin')
  final String? timeBegin;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  final String? type;

  Map<String, Object?> toJson() => _$EntityConsultationResponseToJson(this);
}
