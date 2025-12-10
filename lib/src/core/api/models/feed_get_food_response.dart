// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_food.dart';

part 'feed_get_food_response.g.dart';

@JsonSerializable()
class FeedGetFoodResponse {
  const FeedGetFoodResponse({
    this.list,
  });
  
  factory FeedGetFoodResponse.fromJson(Map<String, Object?> json) => _$FeedGetFoodResponseFromJson(json);
  
  final List<EntityFood>? list;

  Map<String, Object?> toJson() => _$FeedGetFoodResponseToJson(this);
}
