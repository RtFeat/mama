// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_delete_dto.g.dart';

@JsonSerializable()
class ArticleDeleteDto {
  const ArticleDeleteDto({
    required this.photoId,
  });
  
  factory ArticleDeleteDto.fromJson(Map<String, Object?> json) => _$ArticleDeleteDtoFromJson(json);
  
  @JsonKey(name: 'photo_id')
  final String photoId;

  Map<String, Object?> toJson() => _$ArticleDeleteDtoToJson(this);
}
