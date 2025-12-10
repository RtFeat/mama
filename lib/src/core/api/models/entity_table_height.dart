// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_current_height.dart';
import 'entity_current_height_struct.dart';
import 'entity_dynamics_height.dart';

part 'entity_table_height.g.dart';

@JsonSerializable()
class EntityTableHeight {
  const EntityTableHeight({
    this.currentHeight,
    this.dynamicsHeight,
    this.table,
  });
  
  factory EntityTableHeight.fromJson(Map<String, Object?> json) => _$EntityTableHeightFromJson(json);
  
  @JsonKey(name: 'current_height')
  final EntityCurrentHeight? currentHeight;
  @JsonKey(name: 'dynamics_height')
  final EntityDynamicsHeight? dynamicsHeight;
  final List<EntityCurrentHeightStruct>? table;

  Map<String, Object?> toJson() => _$EntityTableHeightToJson(this);
}
