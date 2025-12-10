// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots2.g.dart';

@JsonSerializable()
class WorkSlots2 {
  const WorkSlots2({
    this.workSlot,
  });
  
  factory WorkSlots2.fromJson(Map<String, Object?> json) => _$WorkSlots2FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots2ToJson(this);
}
