// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_response_article_id.g.dart';

@JsonSerializable()
class ArticleResponseArticleID {
  const ArticleResponseArticleID({
    this.id,
  });
  
  factory ArticleResponseArticleID.fromJson(Map<String, Object?> json) => _$ArticleResponseArticleIDFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$ArticleResponseArticleIDToJson(this);
}
