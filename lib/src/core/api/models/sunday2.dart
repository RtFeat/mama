// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_consultation_slot.dart';
import 'entity_work_slot.dart';

part 'sunday2.g.dart';

@JsonSerializable()
class Sunday2 {
  const Sunday2({
    this.consultations,
    this.workSlots,
  });
  
  factory Sunday2.fromJson(Map<String, Object?> json) => _$Sunday2FromJson(json);
  
  final List<EntityConsultationSlot>? consultations;
  @JsonKey(name: 'work_slots')
  final List<EntityWorkSlot>? workSlots;

  Map<String, Object?> toJson() => _$Sunday2ToJson(this);
}
