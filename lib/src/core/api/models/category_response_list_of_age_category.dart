// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_age_category_quantity.dart';

part 'category_response_list_of_age_category.g.dart';

@JsonSerializable()
class CategoryResponseListOfAgeCategory {
  const CategoryResponseListOfAgeCategory({
    this.list,
  });
  
  factory CategoryResponseListOfAgeCategory.fromJson(Map<String, Object?> json) => _$CategoryResponseListOfAgeCategoryFromJson(json);
  
  final List<EntityAgeCategoryQuantity>? list;

  Map<String, Object?> toJson() => _$CategoryResponseListOfAgeCategoryToJson(this);
}
