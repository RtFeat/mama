// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_dynamics_circle.g.dart';

@JsonSerializable()
class EntityDynamicsCircle {
  const EntityDynamicsCircle({
    this.circleGain,
    this.circleToDay,
    this.days,
    this.timeDuration,
  });
  
  factory EntityDynamicsCircle.fromJson(Map<String, Object?> json) => _$EntityDynamicsCircleFromJson(json);
  
  @JsonKey(name: 'circle_gain')
  final String? circleGain;
  @JsonKey(name: 'circle_to_day')
  final String? circleToDay;
  final String? days;
  @JsonKey(name: 'time_duration')
  final String? timeDuration;

  Map<String, Object?> toJson() => _$EntityDynamicsCircleToJson(this);
}
