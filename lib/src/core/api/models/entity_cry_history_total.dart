// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_cry_history.dart';

part 'entity_cry_history_total.g.dart';

@JsonSerializable()
class EntityCryHistoryTotal {
  const EntityCryHistoryTotal({
    this.cryTotal,
    this.months,
    this.time,
    this.timeToEndTotal,
  });
  
  factory EntityCryHistoryTotal.fromJson(Map<String, Object?> json) => _$EntityCryHistoryTotalFromJson(json);
  
  @JsonKey(name: 'Cry_total')
  final List<EntityCryHistory>? cryTotal;
  final String? months;
  final String? time;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;

  Map<String, Object?> toJson() => _$EntityCryHistoryTotalToJson(this);
}
