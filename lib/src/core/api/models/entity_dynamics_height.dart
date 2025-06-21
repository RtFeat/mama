// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_dynamics_height.g.dart';

@JsonSerializable()
class EntityDynamicsHeight {
  const EntityDynamicsHeight({
    this.days,
    this.heightGain,
    this.heightToDay,
    this.timeDuration,
  });
  
  factory EntityDynamicsHeight.fromJson(Map<String, Object?> json) => _$EntityDynamicsHeightFromJson(json);
  
  final String? days;
  @JsonKey(name: 'height_gain')
  final String? heightGain;
  @JsonKey(name: 'height_to_day')
  final String? heightToDay;
  @JsonKey(name: 'time_duration')
  final String? timeDuration;

  Map<String, Object?> toJson() => _$EntityDynamicsHeightToJson(this);
}
