// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_insert_pumping_dto.g.dart';

@JsonSerializable()
class FeedInsertPumpingDto {
  const FeedInsertPumpingDto({
    this.all,
    this.childId,
    this.left,
    this.notes,
    this.right,
    this.timeToEnd,
  });
  
  factory FeedInsertPumpingDto.fromJson(Map<String, Object?> json) => _$FeedInsertPumpingDtoFromJson(json);
  
  final int? all;
  @JsonKey(name: 'child_id')
  final String? childId;
  final int? left;
  final String? notes;
  final int? right;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;

  Map<String, Object?> toJson() => _$FeedInsertPumpingDtoToJson(this);
}
