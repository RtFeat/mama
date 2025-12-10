// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_tag.g.dart';

@JsonSerializable()
class EntityTag {
  const EntityTag({
    this.id,
    this.name,
  });
  
  factory EntityTag.fromJson(Map<String, Object?> json) => _$EntityTagFromJson(json);
  
  final String? id;
  final String? name;

  Map<String, Object?> toJson() => _$EntityTagToJson(this);
}
