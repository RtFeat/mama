// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_body_response.dart';

part 'entity_native_article.g.dart';

@JsonSerializable()
class EntityNativeArticle {
  const EntityNativeArticle({
    this.author,
    this.body,
    this.title,
  });
  
  factory EntityNativeArticle.fromJson(Map<String, Object?> json) => _$EntityNativeArticleFromJson(json);
  
  final EntityAccount? author;
  final List<EntityBodyResponse>? body;
  final String? title;

  Map<String, Object?> toJson() => _$EntityNativeArticleToJson(this);
}
