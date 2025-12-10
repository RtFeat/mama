// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_response_insert_dto.g.dart';

@JsonSerializable()
class FeedResponseInsertDto {
  const FeedResponseInsertDto({
    this.id,
  });
  
  factory FeedResponseInsertDto.fromJson(Map<String, Object?> json) => _$FeedResponseInsertDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$FeedResponseInsertDtoToJson(this);
}
