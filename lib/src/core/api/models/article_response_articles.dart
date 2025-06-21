// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_article_response.dart';

part 'article_response_articles.g.dart';

@JsonSerializable()
class ArticleResponseArticles {
  const ArticleResponseArticles({
    this.articles,
  });
  
  factory ArticleResponseArticles.fromJson(Map<String, Object?> json) => _$ArticleResponseArticlesFromJson(json);
  
  final List<EntityArticleResponse>? articles;

  Map<String, Object?> toJson() => _$ArticleResponseArticlesToJson(this);
}
