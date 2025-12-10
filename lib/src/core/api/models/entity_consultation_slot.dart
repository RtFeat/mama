// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_consultation_slot.g.dart';

@JsonSerializable()
class EntityConsultationSlot {
  const EntityConsultationSlot({
    this.consultationId,
    this.consultationTime,
    this.consultationType,
    this.patientFullName,
  });
  
  factory EntityConsultationSlot.fromJson(Map<String, Object?> json) => _$EntityConsultationSlotFromJson(json);
  
  @JsonKey(name: 'consultation_id')
  final String? consultationId;
  @JsonKey(name: 'consultation_time')
  final String? consultationTime;
  @JsonKey(name: 'consultation_type')
  final String? consultationType;
  @JsonKey(name: 'patient_full_name')
  final String? patientFullName;

  Map<String, Object?> toJson() => _$EntityConsultationSlotToJson(this);
}
