// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots7.dart';

part 'wednesday.g.dart';

@JsonSerializable()
class Wednesday {
  const Wednesday({
    this.workSlots,
  });
  
  factory Wednesday.fromJson(Map<String, Object?> json) => _$WednesdayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots7>? workSlots;

  Map<String, Object?> toJson() => _$WednesdayToJson(this);
}
