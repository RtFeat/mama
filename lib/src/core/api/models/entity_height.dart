// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_height.g.dart';

@JsonSerializable()
class EntityHeight {
  const EntityHeight({
    this.childId,
    this.createdAt,
    this.height,
    this.id,
    this.notes,
  });
  
  factory EntityHeight.fromJson(Map<String, Object?> json) => _$EntityHeightFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? height;
  final String? id;
  final String? notes;

  Map<String, Object?> toJson() => _$EntityHeightToJson(this);
}
