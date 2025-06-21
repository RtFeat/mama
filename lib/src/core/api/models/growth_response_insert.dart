// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_response_insert.g.dart';

@JsonSerializable()
class GrowthResponseInsert {
  const GrowthResponseInsert({
    this.id,
  });
  
  factory GrowthResponseInsert.fromJson(Map<String, Object?> json) => _$GrowthResponseInsertFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$GrowthResponseInsertToJson(this);
}
