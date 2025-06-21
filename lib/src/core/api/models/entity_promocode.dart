// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_promocode.g.dart';

@JsonSerializable()
class EntityPromocode {
  const EntityPromocode({
    this.countPromo,
    this.createdAt,
    this.id,
    this.name,
    this.status,
    this.typePromo,
    this.usedAt,
  });
  
  factory EntityPromocode.fromJson(Map<String, Object?> json) => _$EntityPromocodeFromJson(json);
  
  @JsonKey(name: 'count_promo')
  final int? countPromo;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? name;
  final String? status;
  @JsonKey(name: 'type_promo')
  final String? typePromo;
  @JsonKey(name: 'used_at')
  final String? usedAt;

  Map<String, Object?> toJson() => _$EntityPromocodeToJson(this);
}
