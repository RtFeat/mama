// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_cry_history_total.dart';

part 'sleepcry_response_history_cry.g.dart';

@JsonSerializable()
class SleepcryResponseHistoryCry {
  const SleepcryResponseHistoryCry({
    this.list,
  });
  
  factory SleepcryResponseHistoryCry.fromJson(Map<String, Object?> json) => _$SleepcryResponseHistoryCryFromJson(json);
  
  final List<EntityCryHistoryTotal>? list;

  Map<String, Object?> toJson() => _$SleepcryResponseHistoryCryToJson(this);
}
