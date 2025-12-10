// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_insert_lure.g.dart';

@JsonSerializable()
class EntityInsertLure {
  const EntityInsertLure({
    this.childId,
    this.gram,
    this.nameProduct,
    this.notes,
    this.reaction,
    this.timeToEnd,
  });
  
  factory EntityInsertLure.fromJson(Map<String, Object?> json) => _$EntityInsertLureFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  final int? gram;
  @JsonKey(name: 'name_product')
  final String? nameProduct;
  final String? notes;
  final String? reaction;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;

  Map<String, Object?> toJson() => _$EntityInsertLureToJson(this);
}
