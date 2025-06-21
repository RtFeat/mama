// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_circle.g.dart';

@JsonSerializable()
class EntityCurrentCircle {
  const EntityCurrentCircle({
    this.circle,
    this.data,
    this.days,
    this.normal,
  });
  
  factory EntityCurrentCircle.fromJson(Map<String, Object?> json) => _$EntityCurrentCircleFromJson(json);
  
  final String? circle;
  final String? data;
  final String? days;
  final String? normal;

  Map<String, Object?> toJson() => _$EntityCurrentCircleToJson(this);
}
