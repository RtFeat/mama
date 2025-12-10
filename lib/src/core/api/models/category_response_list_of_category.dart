// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_category_quantity.dart';

part 'category_response_list_of_category.g.dart';

@JsonSerializable()
class CategoryResponseListOfCategory {
  const CategoryResponseListOfCategory({
    this.list,
  });
  
  factory CategoryResponseListOfCategory.fromJson(Map<String, Object?> json) => _$CategoryResponseListOfCategoryFromJson(json);
  
  final List<EntityCategoryQuantity>? list;

  Map<String, Object?> toJson() => _$CategoryResponseListOfCategoryToJson(this);
}
