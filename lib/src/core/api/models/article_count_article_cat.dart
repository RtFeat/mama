// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_count_article_cat.g.dart';

@JsonSerializable()
class ArticleCountArticleCat {
  const ArticleCountArticleCat({
    this.list,
  });
  
  factory ArticleCountArticleCat.fromJson(Map<String, Object?> json) => _$ArticleCountArticleCatFromJson(json);
  
  final Map<String, int>? list;

  Map<String, Object?> toJson() => _$ArticleCountArticleCatToJson(this);
}
