// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_weight_struct.g.dart';

@JsonSerializable()
class EntityCurrentWeightStruct {
  const EntityCurrentWeightStruct({
    this.time,
    this.weight,
  });
  
  factory EntityCurrentWeightStruct.fromJson(Map<String, Object?> json) => _$EntityCurrentWeightStructFromJson(json);
  
  final String? time;
  final String? weight;

  Map<String, Object?> toJson() => _$EntityCurrentWeightStructToJson(this);
}
