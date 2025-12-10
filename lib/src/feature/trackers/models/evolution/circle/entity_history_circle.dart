// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_history_circle.g.dart';

@JsonSerializable()
class EntityHistoryCircle {
  EntityHistoryCircle({
    this.allData,
    this.circle,
    this.data,
    this.id,
    this.normal,
    this.notes,
    this.weeks,
  });

  factory EntityHistoryCircle.fromJson(Map<String, Object?> json) =>
      _$EntityHistoryCircleFromJson(json);

  @JsonKey(name: 'all_data')
  final String? allData;
  final String? circle;
  final String? data;
  final String? id;
  final String? normal;
  String? notes;
  final String? weeks;

  Map<String, Object?> toJson() => _$EntityHistoryCircleToJson(this);
}
