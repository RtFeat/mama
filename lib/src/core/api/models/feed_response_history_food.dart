// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_food_history_total.dart';

part 'feed_response_history_food.g.dart';

@JsonSerializable()
class FeedResponseHistoryFood {
  const FeedResponseHistoryFood({
    this.list,
  });
  
  factory FeedResponseHistoryFood.fromJson(Map<String, Object?> json) => _$FeedResponseHistoryFoodFromJson(json);
  
  final List<EntityFoodHistoryTotal>? list;

  Map<String, Object?> toJson() => _$FeedResponseHistoryFoodToJson(this);
}
