// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_article_response.dart';

part 'entity_online_school_response.g.dart';

@JsonSerializable()
class EntityOnlineSchoolResponse {
  const EntityOnlineSchoolResponse({
    this.account,
    this.articleNumber,
    this.articles,
    this.course,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });
  
  factory EntityOnlineSchoolResponse.fromJson(Map<String, Object?> json) => _$EntityOnlineSchoolResponseFromJson(json);
  
  final EntityAccount? account;
  @JsonKey(name: 'article_number')
  final int? articleNumber;
  final List<EntityArticleResponse>? articles;
  final bool? course;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? name;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityOnlineSchoolResponseToJson(this);
}
