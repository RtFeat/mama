// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_article_writer.dart';

part 'article_article_writer.g.dart';

@JsonSerializable()
class ArticleArticleWriter {
  const ArticleArticleWriter({
    this.counter,
    this.writer,
  });
  
  factory ArticleArticleWriter.fromJson(Map<String, Object?> json) => _$ArticleArticleWriterFromJson(json);
  
  final int? counter;
  final EntityArticleWriter? writer;

  Map<String, Object?> toJson() => _$ArticleArticleWriterToJson(this);
}
