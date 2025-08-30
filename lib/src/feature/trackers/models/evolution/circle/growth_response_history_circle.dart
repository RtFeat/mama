// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_history_circle.dart';

part 'growth_response_history_circle.g.dart';

@JsonSerializable()
class GrowthResponseHistoryCircle {
  const GrowthResponseHistoryCircle({
    this.list,
  });
  
  factory GrowthResponseHistoryCircle.fromJson(Map<String, Object?> json) => _$GrowthResponseHistoryCircleFromJson(json);
  
  final List<EntityHistoryCircle>? list;

  Map<String, Object?> toJson() => _$GrowthResponseHistoryCircleToJson(this);
}
