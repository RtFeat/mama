// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_body_response.dart';
import 'entity_doctor_base.dart';
import 'entity_online_school.dart';

part 'entity_article_response.g.dart';

@JsonSerializable()
class EntityArticleResponse {
  const EntityArticleResponse({
    this.account,
    this.ageCategory,
    this.body,
    this.category,
    this.countArticlesAuthor,
    this.createdAt,
    this.file,
    this.id,
    this.isFavorite,
    this.photoId,
    this.photoUrl,
    this.status,
    this.subAccountDoctor,
    this.subAccountOnlineSchool,
    this.tags,
    this.title,
  });
  
  factory EntityArticleResponse.fromJson(Map<String, Object?> json) => _$EntityArticleResponseFromJson(json);
  
  final EntityAccount? account;
  @JsonKey(name: 'age_category')
  final List<String>? ageCategory;
  final List<EntityBodyResponse>? body;
  final String? category;
  @JsonKey(name: 'count_articles_author')
  final int? countArticlesAuthor;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? file;
  final String? id;
  @JsonKey(name: 'is_favorite')
  final bool? isFavorite;
  @JsonKey(name: 'photo_id')
  final String? photoId;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  final String? status;
  @JsonKey(name: 'sub_account_doctor')
  final EntityDoctorBase? subAccountDoctor;
  @JsonKey(name: 'sub_account_online_school')
  final EntityOnlineSchool? subAccountOnlineSchool;
  final List<String>? tags;
  final String? title;

  Map<String, Object?> toJson() => _$EntityArticleResponseToJson(this);
}
