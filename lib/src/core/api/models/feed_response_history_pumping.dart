// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_pumping_history_total.dart';

part 'feed_response_history_pumping.g.dart';

@JsonSerializable()
class FeedResponseHistoryPumping {
  const FeedResponseHistoryPumping({
    this.list,
  });
  
  factory FeedResponseHistoryPumping.fromJson(Map<String, Object?> json) => _$FeedResponseHistoryPumpingFromJson(json);
  
  final List<EntityPumpingHistoryTotal>? list;

  Map<String, Object?> toJson() => _$FeedResponseHistoryPumpingToJson(this);
}
