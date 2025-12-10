// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots.g.dart';

@JsonSerializable()
class WorkSlots {
  const WorkSlots({
    this.workSlot,
  });
  
  factory WorkSlots.fromJson(Map<String, Object?> json) => _$WorkSlotsFromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlotsToJson(this);
}
