// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table_circle.dart';

part 'growth_get_circle_response.g.dart';

@JsonSerializable()
class GrowthGetCircleResponse {
  const GrowthGetCircleResponse({
    this.list,
  });
  
  factory GrowthGetCircleResponse.fromJson(Map<String, Object?> json) => _$GrowthGetCircleResponseFromJson(json);
  
  final EntityTableCircle? list;

  Map<String, Object?> toJson() => _$GrowthGetCircleResponseToJson(this);
}
