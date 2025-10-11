// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_delete_food_dto.g.dart';

@JsonSerializable()
class FeedDeleteFoodDto {
  const FeedDeleteFoodDto({
    required this.id,
  });
  
  factory FeedDeleteFoodDto.fromJson(Map<String, Object?> json) => _$FeedDeleteFoodDtoFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$FeedDeleteFoodDtoToJson(this);
}
