// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_cry_history.g.dart';

@JsonSerializable()
class EntityCryHistory {
  const EntityCryHistory({
    this.notes,
    this.timeAll,
    this.timeEnd,
    this.timeStart,
  });
  
  factory EntityCryHistory.fromJson(Map<String, Object?> json) => _$EntityCryHistoryFromJson(json);
  
  final String? notes;
  @JsonKey(name: 'time_all')
  final String? timeAll;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_start')
  final String? timeStart;

  Map<String, Object?> toJson() => _$EntityCryHistoryToJson(this);
}
