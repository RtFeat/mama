// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_height.g.dart';

@JsonSerializable()
class EntityCurrentHeight {
  const EntityCurrentHeight({
    this.data,
    this.days,
    this.height,
    this.normal,
  });
  
  factory EntityCurrentHeight.fromJson(Map<String, Object?> json) => _$EntityCurrentHeightFromJson(json);
  
  final String? data;
  final String? days;
  final String? height;
  final String? normal;

  Map<String, Object?> toJson() => _$EntityCurrentHeightToJson(this);
}
