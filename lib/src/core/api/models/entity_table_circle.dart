// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_current_circle.dart';
import 'entity_current_circle_struct.dart';
import 'entity_dynamics_circle.dart';

part 'entity_table_circle.g.dart';

@JsonSerializable()
class EntityTableCircle {
  const EntityTableCircle({
    this.currentCircle,
    this.dynamicsCircle,
    this.table,
  });
  
  factory EntityTableCircle.fromJson(Map<String, Object?> json) => _$EntityTableCircleFromJson(json);
  
  @JsonKey(name: 'current_circle')
  final EntityCurrentCircle? currentCircle;
  @JsonKey(name: 'dynamics_circle')
  final EntityDynamicsCircle? dynamicsCircle;
  final List<EntityCurrentCircleStruct>? table;

  Map<String, Object?> toJson() => _$EntityTableCircleToJson(this);
}
