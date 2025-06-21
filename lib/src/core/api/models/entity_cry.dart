// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_cry.g.dart';

@JsonSerializable()
class EntityCry {
  const EntityCry({
    this.allCry,
    this.childId,
    this.id,
    this.notes,
    this.timeEnd,
    this.timeToEnd,
    this.timeToStart,
  });
  
  factory EntityCry.fromJson(Map<String, Object?> json) => _$EntityCryFromJson(json);
  
  @JsonKey(name: 'all_cry')
  final String? allCry;
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? id;
  final String? notes;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;
  @JsonKey(name: 'time_to_start')
  final String? timeToStart;

  Map<String, Object?> toJson() => _$EntityCryToJson(this);
}
