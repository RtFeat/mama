// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_get_weight.dart';

part 'growth_response_get_weight.g.dart';

@JsonSerializable()
class GrowthResponseGetWeight {
  const GrowthResponseGetWeight({
    this.list,
  });
  
  factory GrowthResponseGetWeight.fromJson(Map<String, Object?> json) => _$GrowthResponseGetWeightFromJson(json);
  
  final EntityGetWeight? list;

  Map<String, Object?> toJson() => _$GrowthResponseGetWeightToJson(this);
}
