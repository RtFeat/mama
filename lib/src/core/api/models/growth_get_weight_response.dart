// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_weight.dart';

part 'growth_get_weight_response.g.dart';

@JsonSerializable()
class GrowthGetWeightResponse {
  const GrowthGetWeightResponse({
    this.list,
  });
  
  factory GrowthGetWeightResponse.fromJson(Map<String, Object?> json) => _$GrowthGetWeightResponseFromJson(json);
  
  final EntityTableWeight? list;

  Map<String, Object?> toJson() => _$GrowthGetWeightResponseToJson(this);
}
