// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_article_response.dart';

part 'article_get_article_for_you.g.dart';

@JsonSerializable()
class ArticleGetArticleForYou {
  const ArticleGetArticleForYou({
    this.list,
  });
  
  factory ArticleGetArticleForYou.fromJson(Map<String, Object?> json) => _$ArticleGetArticleForYouFromJson(json);
  
  final List<EntityArticleResponse>? list;

  Map<String, Object?> toJson() => _$ArticleGetArticleForYouToJson(this);
}
