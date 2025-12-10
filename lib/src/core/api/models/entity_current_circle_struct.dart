// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_circle_struct.g.dart';

@JsonSerializable()
class EntityCurrentCircleStruct {
  const EntityCurrentCircleStruct({
    this.circle,
    this.time,
  });
  
  factory EntityCurrentCircleStruct.fromJson(Map<String, Object?> json) => _$EntityCurrentCircleStructFromJson(json);
  
  final String? circle;
  final String? time;

  Map<String, Object?> toJson() => _$EntityCurrentCircleStructToJson(this);
}
