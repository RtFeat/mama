// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_tag.dart';

part 'tags_response_tags.g.dart';

@JsonSerializable()
class TagsResponseTags {
  const TagsResponseTags({
    this.tags,
  });
  
  factory TagsResponseTags.fromJson(Map<String, Object?> json) => _$TagsResponseTagsFromJson(json);
  
  final List<EntityTag>? tags;

  Map<String, Object?> toJson() => _$TagsResponseTagsToJson(this);
}
