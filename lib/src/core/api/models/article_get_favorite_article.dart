// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_favorite_article_response.dart';

part 'article_get_favorite_article.g.dart';

@JsonSerializable()
class ArticleGetFavoriteArticle {
  const ArticleGetFavoriteArticle({
    this.articles,
  });
  
  factory ArticleGetFavoriteArticle.fromJson(Map<String, Object?> json) => _$ArticleGetFavoriteArticleFromJson(json);
  
  final List<EntityFavoriteArticleResponse>? articles;

  Map<String, Object?> toJson() => _$ArticleGetFavoriteArticleToJson(this);
}
