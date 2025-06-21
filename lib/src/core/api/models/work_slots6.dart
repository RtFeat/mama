// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots6.g.dart';

@JsonSerializable()
class WorkSlots6 {
  const WorkSlots6({
    this.workSlot,
  });
  
  factory WorkSlots6.fromJson(Map<String, Object?> json) => _$WorkSlots6FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots6ToJson(this);
}
