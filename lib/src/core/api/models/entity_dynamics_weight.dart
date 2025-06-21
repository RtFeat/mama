// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_dynamics_weight.g.dart';

@JsonSerializable()
class EntityDynamicsWeight {
  const EntityDynamicsWeight({
    this.days,
    this.timeDuration,
    this.weightGain,
    this.weightToDay,
  });
  
  factory EntityDynamicsWeight.fromJson(Map<String, Object?> json) => _$EntityDynamicsWeightFromJson(json);
  
  final String? days;
  @JsonKey(name: 'time_duration')
  final String? timeDuration;
  @JsonKey(name: 'weight_gain')
  final String? weightGain;
  @JsonKey(name: 'weight_to_day')
  final String? weightToDay;

  Map<String, Object?> toJson() => _$EntityDynamicsWeightToJson(this);
}
