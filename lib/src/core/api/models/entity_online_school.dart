// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_online_school.g.dart';

@JsonSerializable()
class EntityOnlineSchool {
  const EntityOnlineSchool({
    this.account,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });
  
  factory EntityOnlineSchool.fromJson(Map<String, Object?> json) => _$EntityOnlineSchoolFromJson(json);
  
  final String? account;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? name;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityOnlineSchoolToJson(this);
}
