// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots.dart';

part 'friday.g.dart';

@JsonSerializable()
class Friday {
  const Friday({
    this.workSlots,
  });
  
  factory Friday.fromJson(Map<String, Object?> json) => _$FridayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots>? workSlots;

  Map<String, Object?> toJson() => _$FridayToJson(this);
}
