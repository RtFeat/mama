// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_get_height.dart';

part 'growth_response_get_height.g.dart';

@JsonSerializable()
class GrowthResponseGetHeight {
  const GrowthResponseGetHeight({
    this.list,
  });
  
  factory GrowthResponseGetHeight.fromJson(Map<String, Object?> json) => _$GrowthResponseGetHeightFromJson(json);
  
  final EntityGetHeight? list;

  Map<String, Object?> toJson() => _$GrowthResponseGetHeightToJson(this);
}
