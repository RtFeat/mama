// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_work_slot.g.dart';

@JsonSerializable()
class EntityWorkSlot {
  const EntityWorkSlot({
    this.workSlot,
  });
  
  factory EntityWorkSlot.fromJson(Map<String, Object?> json) => _$EntityWorkSlotFromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$EntityWorkSlotToJson(this);
}
