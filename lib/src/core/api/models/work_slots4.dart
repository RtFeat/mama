// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots4.g.dart';

@JsonSerializable()
class WorkSlots4 {
  const WorkSlots4({
    this.workSlot,
  });
  
  factory WorkSlots4.fromJson(Map<String, Object?> json) => _$WorkSlots4FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots4ToJson(this);
}
