// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_feed.dart';

part 'entity_table_feed_total.g.dart';

@JsonSerializable()
class EntityTableFeedTotal {
  const EntityTableFeedTotal({
    this.table,
    this.timeToEndTotal,
  });
  
  factory EntityTableFeedTotal.fromJson(Map<String, Object?> json) => _$EntityTableFeedTotalFromJson(json);
  
  final List<EntityTableFeed>? table;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;

  Map<String, Object?> toJson() => _$EntityTableFeedTotalToJson(this);
}
