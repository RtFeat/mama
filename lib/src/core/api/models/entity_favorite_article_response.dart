// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_favorite_article_response.g.dart';

@JsonSerializable()
class EntityFavoriteArticleResponse {
  const EntityFavoriteArticleResponse({
    this.ageCategory,
    this.articlePhoto,
    this.author,
    this.authorAvatar,
    this.authorProfession,
    this.category,
    this.id,
    this.title,
  });
  
  factory EntityFavoriteArticleResponse.fromJson(Map<String, Object?> json) => _$EntityFavoriteArticleResponseFromJson(json);
  
  @JsonKey(name: 'age_category')
  final List<String>? ageCategory;
  @JsonKey(name: 'article_photo')
  final String? articlePhoto;
  final String? author;
  @JsonKey(name: 'author_avatar')
  final String? authorAvatar;
  @JsonKey(name: 'author_profession')
  final String? authorProfession;
  final String? category;
  final String? id;
  final String? title;

  Map<String, Object?> toJson() => _$EntityFavoriteArticleResponseToJson(this);
}
