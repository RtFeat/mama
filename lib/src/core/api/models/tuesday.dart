// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots6.dart';

part 'tuesday.g.dart';

@JsonSerializable()
class Tuesday {
  const Tuesday({
    this.workSlots,
  });
  
  factory Tuesday.fromJson(Map<String, Object?> json) => _$TuesdayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots6>? workSlots;

  Map<String, Object?> toJson() => _$TuesdayToJson(this);
}
