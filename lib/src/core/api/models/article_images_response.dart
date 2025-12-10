// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_article_image.dart';

part 'article_images_response.g.dart';

@JsonSerializable()
class ArticleImagesResponse {
  const ArticleImagesResponse({
    this.images,
  });
  
  factory ArticleImagesResponse.fromJson(Map<String, Object?> json) => _$ArticleImagesResponseFromJson(json);
  
  final List<EntityArticleImage>? images;

  Map<String, Object?> toJson() => _$ArticleImagesResponseToJson(this);
}
