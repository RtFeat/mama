// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_article_image.g.dart';

@JsonSerializable()
class EntityArticleImage {
  const EntityArticleImage({
    this.id,
    this.index,
    this.photoId,
    this.photoUrl,
  });
  
  factory EntityArticleImage.fromJson(Map<String, Object?> json) => _$EntityArticleImageFromJson(json);
  
  final String? id;
  final int? index;
  @JsonKey(name: 'photo_id')
  final String? photoId;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  Map<String, Object?> toJson() => _$EntityArticleImageToJson(this);
}
