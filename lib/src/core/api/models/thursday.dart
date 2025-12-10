// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots5.dart';

part 'thursday.g.dart';

@JsonSerializable()
class Thursday {
  const Thursday({
    this.workSlots,
  });
  
  factory Thursday.fromJson(Map<String, Object?> json) => _$ThursdayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots5>? workSlots;

  Map<String, Object?> toJson() => _$ThursdayToJson(this);
}
