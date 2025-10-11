// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_lure_history.g.dart';

@JsonSerializable()
class EntityLureHistory {
  const EntityLureHistory({
    this.id,
    this.gram,
    this.nameProduct,
    this.notes,
    this.reaction,
    this.time,
  });
  
  factory EntityLureHistory.fromJson(Map<String, Object?> json) => _$EntityLureHistoryFromJson(json);
  
  final String? id;
  final int? gram;
  @JsonKey(name: 'name_product')
  final String? nameProduct;
  final String? notes;
  final String? reaction;
  final String? time;

  Map<String, Object?> toJson() => _$EntityLureHistoryToJson(this);
}
