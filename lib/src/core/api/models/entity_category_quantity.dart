// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_category_quantity.g.dart';

@JsonSerializable()
class EntityCategoryQuantity {
  const EntityCategoryQuantity({
    this.id,
    this.name,
    this.quantity,
  });
  
  factory EntityCategoryQuantity.fromJson(Map<String, Object?> json) => _$EntityCategoryQuantityFromJson(json);
  
  final String? id;
  final String? name;
  final int? quantity;

  Map<String, Object?> toJson() => _$EntityCategoryQuantityToJson(this);
}
