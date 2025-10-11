// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_delete_lure_dto.g.dart';

@JsonSerializable()
class FeedDeleteLureDto {
  const FeedDeleteLureDto({
    required this.id,
  });
  
  factory FeedDeleteLureDto.fromJson(Map<String, Object?> json) => _$FeedDeleteLureDtoFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$FeedDeleteLureDtoToJson(this);
}
