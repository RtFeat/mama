// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'work_slots3.g.dart';

@JsonSerializable()
class WorkSlots3 {
  const WorkSlots3({
    this.workSlot,
  });
  
  factory WorkSlots3.fromJson(Map<String, Object?> json) => _$WorkSlots3FromJson(json);
  
  @JsonKey(name: 'work_slot')
  final String? workSlot;

  Map<String, Object?> toJson() => _$WorkSlots3ToJson(this);
}
