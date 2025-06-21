// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_get_circle.dart';

part 'growth_response_get_circle.g.dart';

@JsonSerializable()
class GrowthResponseGetCircle {
  const GrowthResponseGetCircle({
    this.list,
  });
  
  factory GrowthResponseGetCircle.fromJson(Map<String, Object?> json) => _$GrowthResponseGetCircleFromJson(json);
  
  final EntityGetCircle? list;

  Map<String, Object?> toJson() => _$GrowthResponseGetCircleToJson(this);
}
