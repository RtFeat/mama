// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_table.dart';

part 'growth_get_table_response.g.dart';

@JsonSerializable()
class GrowthGetTableResponse {
  const GrowthGetTableResponse({
    this.list,
  });

  factory GrowthGetTableResponse.fromJson(Map<String, Object?> json) =>
      _$GrowthGetTableResponseFromJson(json);

  final List<EntityTable>? list;

  Map<String, Object?> toJson() => _$GrowthGetTableResponseToJson(this);
}
