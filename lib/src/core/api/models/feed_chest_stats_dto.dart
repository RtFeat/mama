// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_chest_stats_dto.g.dart';

@JsonSerializable()
class FeedChestStatsDto {
  const FeedChestStatsDto({
    required this.id,
    required this.left,
    required this.right,
    required this.timeToEnd,
  });
  
  factory FeedChestStatsDto.fromJson(Map<String, Object?> json) => _$FeedChestStatsDtoFromJson(json);
  
  final String id;
  final int left;
  final int right;
  final String timeToEnd;

  Map<String, Object?> toJson() => _$FeedChestStatsDtoToJson(this);
}
