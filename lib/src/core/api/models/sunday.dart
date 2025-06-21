// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots4.dart';

part 'sunday.g.dart';

@JsonSerializable()
class Sunday {
  const Sunday({
    this.workSlots,
  });
  
  factory Sunday.fromJson(Map<String, Object?> json) => _$SundayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots4>? workSlots;

  Map<String, Object?> toJson() => _$SundayToJson(this);
}
