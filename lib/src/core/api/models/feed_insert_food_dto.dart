// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_insert_food_dto.g.dart';

@JsonSerializable()
class FeedInsertFoodDto {
  const FeedInsertFoodDto({
    this.chest,
    this.childId,
    this.mixture,
    this.notes,
    this.timeToEnd,
  });
  
  factory FeedInsertFoodDto.fromJson(Map<String, Object?> json) => _$FeedInsertFoodDtoFromJson(json);
  
  final int? chest;
  @JsonKey(name: 'child_id')
  final String? childId;
  final int? mixture;
  final String? notes;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;

  Map<String, Object?> toJson() => _$FeedInsertFoodDtoToJson(this);
}
