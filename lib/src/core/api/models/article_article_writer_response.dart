// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'article_article_writer.dart';

part 'article_article_writer_response.g.dart';

@JsonSerializable()
class ArticleArticleWriterResponse {
  const ArticleArticleWriterResponse({
    this.list,
  });
  
  factory ArticleArticleWriterResponse.fromJson(Map<String, Object?> json) => _$ArticleArticleWriterResponseFromJson(json);
  
  final List<ArticleArticleWriter>? list;

  Map<String, Object?> toJson() => _$ArticleArticleWriterResponseToJson(this);
}
