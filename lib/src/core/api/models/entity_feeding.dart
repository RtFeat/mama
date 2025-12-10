// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_feeding.g.dart';

@JsonSerializable()
class EntityFeeding {
  const EntityFeeding({
    this.allFeeding,
    this.childId,
    this.id,
    this.leftFeeding,
    this.notes,
    this.rightFeeding,
    this.timeToEnd,
  });
  
  factory EntityFeeding.fromJson(Map<String, Object?> json) => _$EntityFeedingFromJson(json);
  
  @JsonKey(name: 'all_feeding')
  final int? allFeeding;
  @JsonKey(name: 'child_id')
  final String? childId;
  final String? id;
  @JsonKey(name: 'left_feeding')
  final int? leftFeeding;
  final String? notes;
  @JsonKey(name: 'right_feeding')
  final int? rightFeeding;
  @JsonKey(name: 'time_to_end')
  final String? timeToEnd;

  Map<String, Object?> toJson() => _$EntityFeedingToJson(this);
}
