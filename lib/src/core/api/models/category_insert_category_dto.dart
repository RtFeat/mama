// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'category_insert_category_dto.g.dart';

@JsonSerializable()
class CategoryInsertCategoryDto {
  const CategoryInsertCategoryDto({
    this.name,
  });
  
  factory CategoryInsertCategoryDto.fromJson(Map<String, Object?> json) => _$CategoryInsertCategoryDtoFromJson(json);
  
  final String? name;

  Map<String, Object?> toJson() => _$CategoryInsertCategoryDtoToJson(this);
}
