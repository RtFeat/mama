// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_wight.g.dart';

@JsonSerializable()
class EntityCurrentWight {
  const EntityCurrentWight({
    this.data,
    this.days,
    this.normal,
    this.weight,
  });
  
  factory EntityCurrentWight.fromJson(Map<String, Object?> json) => _$EntityCurrentWightFromJson(json);
  
  final String? data;
  final String? days;
  final String? normal;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityCurrentWightToJson(this);
}
