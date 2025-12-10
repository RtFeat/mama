// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_list_article_response.g.dart';

@JsonSerializable()
class EntityListArticleResponse {
  const EntityListArticleResponse({
    this.ageCategory,
    this.category,
    this.id,
    this.photoId,
    this.photoUrl,
    this.title,
  });
  
  factory EntityListArticleResponse.fromJson(Map<String, Object?> json) => _$EntityListArticleResponseFromJson(json);
  
  @JsonKey(name: 'age_category')
  final List<String>? ageCategory;
  final String? category;
  final String? id;
  @JsonKey(name: 'photo_id')
  final String? photoId;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  final String? title;

  Map<String, Object?> toJson() => _$EntityListArticleResponseToJson(this);
}
