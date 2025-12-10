// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots2.dart';

part 'monday.g.dart';

@JsonSerializable()
class Monday {
  const Monday({
    this.workSlots,
  });
  
  factory Monday.fromJson(Map<String, Object?> json) => _$MondayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots2>? workSlots;

  Map<String, Object?> toJson() => _$MondayToJson(this);
}
