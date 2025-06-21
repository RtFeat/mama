// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_lure_history.dart';

part 'entity_lure_history_total.g.dart';

@JsonSerializable()
class EntityLureHistoryTotal {
  const EntityLureHistoryTotal({
    this.pumpingLure,
    this.object1,
    this.timeToEndTotal,
  });

  factory EntityLureHistoryTotal.fromJson(Map<String, Object?> json) =>
      _$EntityLureHistoryTotalFromJson(json);

  @JsonKey(name: 'pumping_lure')
  final List<EntityLureHistory>? pumpingLure;

  /// Incorrect name has been replaced. Original name: `time_to_end_don't_use'`.
  @JsonKey(name: "time_to_end_don't_use")
  final String? object1;
  @JsonKey(name: 'time_to_end_total')
  final String? timeToEndTotal;

  Map<String, Object?> toJson() => _$EntityLureHistoryTotalToJson(this);
}
