// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots5.g.dart';

@JsonSerializable()
class WorkSlots5 {
  const WorkSlots5({
    this.workSlot,
  });
  
  factory WorkSlots5.fromJson(Map<String, Object?> json) => _$WorkSlots5FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots5ToJson(this);
}
