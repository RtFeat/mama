// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_current_weight_struct.dart';
import 'entity_current_wight.dart';
import 'entity_dynamics_weight.dart';

part 'entity_table_weight.g.dart';

@JsonSerializable()
class EntityTableWeight {
  const EntityTableWeight({
    this.currentWeight,
    this.dynamicsWeight,
    this.table,
  });
  
  factory EntityTableWeight.fromJson(Map<String, Object?> json) => _$EntityTableWeightFromJson(json);
  
  @JsonKey(name: 'current_weight')
  final EntityCurrentWight? currentWeight;
  @JsonKey(name: 'dynamics_weight')
  final EntityDynamicsWeight? dynamicsWeight;
  final List<EntityCurrentWeightStruct>? table;

  Map<String, Object?> toJson() => _$EntityTableWeightToJson(this);
}
