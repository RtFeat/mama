// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots7.g.dart';

@JsonSerializable()
class WorkSlots7 {
  const WorkSlots7({
    this.workSlot,
  });
  
  factory WorkSlots7.fromJson(Map<String, Object?> json) => _$WorkSlots7FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots7ToJson(this);
}
