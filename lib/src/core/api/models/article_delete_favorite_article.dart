// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_delete_favorite_article.g.dart';

@JsonSerializable()
class ArticleDeleteFavoriteArticle {
  const ArticleDeleteFavoriteArticle({
    this.articleId,
  });
  
  factory ArticleDeleteFavoriteArticle.fromJson(Map<String, Object?> json) => _$ArticleDeleteFavoriteArticleFromJson(json);
  
  @JsonKey(name: 'article_id')
  final String? articleId;

  Map<String, Object?> toJson() => _$ArticleDeleteFavoriteArticleToJson(this);
}
