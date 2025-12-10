// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_chest_history.g.dart';

@JsonSerializable()
class EntityChestHistory {
  const EntityChestHistory({
    this.left,
    this.notes,
    this.right,
    this.time,
    this.total,
  });
  
  factory EntityChestHistory.fromJson(Map<String, Object?> json) => _$EntityChestHistoryFromJson(json);
  
  final int? left;
  final String? notes;
  final int? right;
  final String? time;
  final int? total;

  Map<String, Object?> toJson() => _$EntityChestHistoryToJson(this);
}
