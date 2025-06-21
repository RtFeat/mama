// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_list_article_response.dart';

part 'article_list_articles.g.dart';

@JsonSerializable()
class ArticleListArticles {
  const ArticleListArticles({
    this.articles,
  });
  
  factory ArticleListArticles.fromJson(Map<String, Object?> json) => _$ArticleListArticlesFromJson(json);
  
  final List<EntityListArticleResponse>? articles;

  Map<String, Object?> toJson() => _$ArticleListArticlesToJson(this);
}
