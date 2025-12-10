// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_weight.g.dart';

@JsonSerializable()
class EntityWeight {
  const EntityWeight({
    this.childId,
    this.createdAt,
    this.id,
    this.notes,
    this.weight,
  });
  
  factory EntityWeight.fromJson(Map<String, Object?> json) => _$EntityWeightFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? notes;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityWeightToJson(this);
}
