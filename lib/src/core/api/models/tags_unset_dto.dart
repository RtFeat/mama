// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'tags_unset_dto.g.dart';

@JsonSerializable()
class TagsUnsetDto {
  const TagsUnsetDto({
    this.articleId,
    this.tagId,
  });
  
  factory TagsUnsetDto.fromJson(Map<String, Object?> json) => _$TagsUnsetDtoFromJson(json);
  
  @JsonKey(name: 'article_id')
  final String? articleId;
  @JsonKey(name: 'tag_id')
  final String? tagId;

  Map<String, Object?> toJson() => _$TagsUnsetDtoToJson(this);
}
