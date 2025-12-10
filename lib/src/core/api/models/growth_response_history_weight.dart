// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_history_weight.dart';

part 'growth_response_history_weight.g.dart';

@JsonSerializable()
class GrowthResponseHistoryWeight {
  const GrowthResponseHistoryWeight({
    this.list,
  });
  
  factory GrowthResponseHistoryWeight.fromJson(Map<String, Object?> json) => _$GrowthResponseHistoryWeightFromJson(json);
  
  final List<EntityHistoryWeight>? list;

  Map<String, Object?> toJson() => _$GrowthResponseHistoryWeightToJson(this);
}
