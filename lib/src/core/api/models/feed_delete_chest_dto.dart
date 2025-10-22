// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_delete_chest_dto.g.dart';

@JsonSerializable()
class FeedDeleteChestDto {
  const FeedDeleteChestDto({
    required this.id,
  });
  
  factory FeedDeleteChestDto.fromJson(Map<String, Object?> json) => _$FeedDeleteChestDtoFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$FeedDeleteChestDtoToJson(this);
}
