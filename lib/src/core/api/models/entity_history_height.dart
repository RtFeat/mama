// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_history_height.g.dart';

@JsonSerializable()
class EntityHistoryHeight {
  const EntityHistoryHeight({
    this.allData,
    this.data,
    this.height,
    this.id,
    this.normal,
    this.notes,
    this.weeks,
  });
  
  factory EntityHistoryHeight.fromJson(Map<String, Object?> json) => _$EntityHistoryHeightFromJson(json);
  
  @JsonKey(name: 'all_data')
  final String? allData;
  final String? data;
  final String? height;
  final String? id;
  final String? normal;
  final String? notes;
  final String? weeks;

  Map<String, Object?> toJson() => _$EntityHistoryHeightToJson(this);
}
