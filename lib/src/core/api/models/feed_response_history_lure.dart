// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_lure_history_total.dart';

part 'feed_response_history_lure.g.dart';

@JsonSerializable()
class FeedResponseHistoryLure {
  const FeedResponseHistoryLure({
    this.list,
  });
  
  factory FeedResponseHistoryLure.fromJson(Map<String, Object?> json) => _$FeedResponseHistoryLureFromJson(json);
  
  final List<EntityLureHistoryTotal>? list;

  Map<String, Object?> toJson() => _$FeedResponseHistoryLureToJson(this);
}
