// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_table.g.dart';

@JsonSerializable()
class EntityTable {
  const EntityTable({
    this.circle,
    this.data,
    this.dateTime,
    this.height,
    this.normalCircle,
    this.normalHeight,
    this.normalWeight,
    this.notes,
    this.week,
    this.weight,
  });
  
  factory EntityTable.fromJson(Map<String, Object?> json) => _$EntityTableFromJson(json);
  
  final String? circle;
  final String? data;
  @JsonKey(name: 'date_time')
  final String? dateTime;
  final String? height;
  @JsonKey(name: 'normal_circle')
  final String? normalCircle;
  @JsonKey(name: 'normal_height')
  final String? normalHeight;
  @JsonKey(name: 'normal_weight')
  final String? normalWeight;
  final String? notes;
  final String? week;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityTableToJson(this);
}
