// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'tags_create_dto.g.dart';

@JsonSerializable()
class TagsCreateDto {
  const TagsCreateDto({
    this.name,
  });
  
  factory TagsCreateDto.fromJson(Map<String, Object?> json) => _$TagsCreateDtoFromJson(json);
  
  final String? name;

  Map<String, Object?> toJson() => _$TagsCreateDtoToJson(this);
}
