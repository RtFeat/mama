// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_circle.g.dart';

@JsonSerializable()
class EntityCircle {
  const EntityCircle({
    this.childId,
    this.circle,
    this.createdAt,
    this.id,
    this.notes,
  });
  
  factory EntityCircle.fromJson(Map<String, Object?> json) => _$EntityCircleFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? circle;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? notes;

  Map<String, Object?> toJson() => _$EntityCircleToJson(this);
}
