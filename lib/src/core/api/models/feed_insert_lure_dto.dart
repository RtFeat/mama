// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_insert_lure.dart';

part 'feed_insert_lure_dto.g.dart';

@JsonSerializable()
class FeedInsertLureDto {
  const FeedInsertLureDto({
    this.lure,
  });
  
  factory FeedInsertLureDto.fromJson(Map<String, Object?> json) => _$FeedInsertLureDtoFromJson(json);
  
  final List<EntityInsertLure>? lure;

  Map<String, Object?> toJson() => _$FeedInsertLureDtoToJson(this);
}
