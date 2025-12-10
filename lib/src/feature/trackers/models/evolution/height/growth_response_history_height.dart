// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'growth_response_history_height.g.dart';

@JsonSerializable()
class GrowthResponseHistoryHeight {
  const GrowthResponseHistoryHeight({
    this.list,
  });

  factory GrowthResponseHistoryHeight.fromJson(Map<String, Object?> json) =>
      _$GrowthResponseHistoryHeightFromJson(json);

  final List<EntityHistoryHeight>? list;

  Map<String, Object?> toJson() => _$GrowthResponseHistoryHeightToJson(this);
}
