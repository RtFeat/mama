// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_delete_pumping_dto.g.dart';

@JsonSerializable()
class FeedDeletePumpingDto {
  const FeedDeletePumpingDto({
    this.id,
  });
  
  factory FeedDeletePumpingDto.fromJson(Map<String, Object?> json) => _$FeedDeletePumpingDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$FeedDeletePumpingDtoToJson(this);
}
