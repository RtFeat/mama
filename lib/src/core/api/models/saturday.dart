// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'work_slots3.dart';

part 'saturday.g.dart';

@JsonSerializable()
class Saturday {
  const Saturday({
    this.workSlots,
  });
  
  factory Saturday.fromJson(Map<String, Object?> json) => _$SaturdayFromJson(json);
  
  @JsonKey(name: 'work_slots')
  final List<WorkSlots3>? workSlots;

  Map<String, Object?> toJson() => _$SaturdayToJson(this);
}
