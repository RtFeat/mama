// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_feeding.dart';

part 'feed_get_feeding_response.g.dart';

@JsonSerializable()
class FeedGetFeedingResponse {
  const FeedGetFeedingResponse({
    this.list,
  });
  
  factory FeedGetFeedingResponse.fromJson(Map<String, Object?> json) => _$FeedGetFeedingResponseFromJson(json);
  
  final List<EntityFeeding>? list;

  Map<String, Object?> toJson() => _$FeedGetFeedingResponseToJson(this);
}
