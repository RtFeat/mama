// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_article_response.dart';

part 'article_article_response.g.dart';

@JsonSerializable()
class ArticleArticleResponse {
  const ArticleArticleResponse({
    this.article,
  });
  
  factory ArticleArticleResponse.fromJson(Map<String, Object?> json) => _$ArticleArticleResponseFromJson(json);
  
  final EntityArticleResponse? article;

  Map<String, Object?> toJson() => _$ArticleArticleResponseToJson(this);
}
