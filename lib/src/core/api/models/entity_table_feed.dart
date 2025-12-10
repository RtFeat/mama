// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_table_feed.g.dart';

@JsonSerializable()
class EntityTableFeed {
  const EntityTableFeed({
    this.chest,
    this.food,
    this.lure,
    this.notes,
    this.time,
  });
  
  factory EntityTableFeed.fromJson(Map<String, Object?> json) => _$EntityTableFeedFromJson(json);
  
  final String? chest;
  final String? food;
  final String? lure;
  final String? notes;
  final String? time;

  Map<String, Object?> toJson() => _$EntityTableFeedToJson(this);
}
