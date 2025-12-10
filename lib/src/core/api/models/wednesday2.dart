// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_consultation_slot.dart';
import 'entity_work_slot.dart';

part 'wednesday2.g.dart';

@JsonSerializable()
class Wednesday2 {
  const Wednesday2({
    this.consultations,
    this.workSlots,
  });
  
  factory Wednesday2.fromJson(Map<String, Object?> json) => _$Wednesday2FromJson(json);
  
  final List<EntityConsultationSlot>? consultations;
  @JsonKey(name: 'work_slots')
  final List<EntityWorkSlot>? workSlots;

  Map<String, Object?> toJson() => _$Wednesday2ToJson(this);
}
