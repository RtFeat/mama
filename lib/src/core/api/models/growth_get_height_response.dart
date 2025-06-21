// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_height.dart';

part 'growth_get_height_response.g.dart';

@JsonSerializable()
class GrowthGetHeightResponse {
  const GrowthGetHeightResponse({
    this.list,
  });
  
  factory GrowthGetHeightResponse.fromJson(Map<String, Object?> json) => _$GrowthGetHeightResponseFromJson(json);
  
  final EntityTableHeight? list;

  Map<String, Object?> toJson() => _$GrowthGetHeightResponseToJson(this);
}
