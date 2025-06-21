// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_chest_history_total.dart';

part 'feed_response_history_chest.g.dart';

@JsonSerializable()
class FeedResponseHistoryChest {
  const FeedResponseHistoryChest({
    this.list,
  });
  
  factory FeedResponseHistoryChest.fromJson(Map<String, Object?> json) => _$FeedResponseHistoryChestFromJson(json);
  
  final List<EntityChestHistoryTotal>? list;

  Map<String, Object?> toJson() => _$FeedResponseHistoryChestToJson(this);
}
