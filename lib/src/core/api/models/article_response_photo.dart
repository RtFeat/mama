// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_response_photo.g.dart';

@JsonSerializable()
class ArticleResponsePhoto {
  const ArticleResponsePhoto({
    this.filename,
  });
  
  factory ArticleResponsePhoto.fromJson(Map<String, Object?> json) => _$ArticleResponsePhotoFromJson(json);
  
  final String? filename;

  Map<String, Object?> toJson() => _$ArticleResponsePhotoToJson(this);
}
