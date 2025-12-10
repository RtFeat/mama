// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_feed_total.dart';

part 'feed_response_history_table.g.dart';

@JsonSerializable()
class FeedResponseHistoryTable {
  const FeedResponseHistoryTable({
    this.list,
  });
  
  factory FeedResponseHistoryTable.fromJson(Map<String, Object?> json) => _$FeedResponseHistoryTableFromJson(json);
  
  final List<EntityTableFeedTotal>? list;

  Map<String, Object?> toJson() => _$FeedResponseHistoryTableToJson(this);
}
