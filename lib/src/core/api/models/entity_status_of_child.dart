// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_status_of_child.g.dart';

@JsonSerializable()
class EntityStatusOfChild {
  const EntityStatusOfChild({
    this.body,
    this.description,
    this.title,
    this.value,
  });
  
  factory EntityStatusOfChild.fromJson(Map<String, Object?> json) => _$EntityStatusOfChildFromJson(json);
  
  final String? body;
  final String? description;
  final String? title;
  final String? value;

  Map<String, Object?> toJson() => _$EntityStatusOfChildToJson(this);
}
