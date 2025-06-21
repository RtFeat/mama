// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_history_weight.g.dart';

@JsonSerializable()
class EntityHistoryWeight {
  const EntityHistoryWeight({
    this.allData,
    this.data,
    this.id,
    this.normal,
    this.notes,
    this.weeks,
    this.weight,
  });
  
  factory EntityHistoryWeight.fromJson(Map<String, Object?> json) => _$EntityHistoryWeightFromJson(json);
  
  @JsonKey(name: 'all_data')
  final String? allData;
  final String? data;
  final String? id;
  final String? normal;
  final String? notes;
  final String? weeks;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityHistoryWeightToJson(this);
}
