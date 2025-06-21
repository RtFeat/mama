// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_music_categories_dto.g.dart';

@JsonSerializable()
class ModeratorMusicCategoriesDto {
  const ModeratorMusicCategoriesDto({
    this.category,
  });
  
  factory ModeratorMusicCategoriesDto.fromJson(Map<String, Object?> json) => _$ModeratorMusicCategoriesDtoFromJson(json);
  
  final String? category;

  Map<String, Object?> toJson() => _$ModeratorMusicCategoriesDtoToJson(this);
}
