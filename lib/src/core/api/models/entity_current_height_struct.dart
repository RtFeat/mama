// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_current_height_struct.g.dart';

@JsonSerializable()
class EntityCurrentHeightStruct {
  const EntityCurrentHeightStruct({
    this.height,
    this.time,
  });
  
  factory EntityCurrentHeightStruct.fromJson(Map<String, Object?> json) => _$EntityCurrentHeightStructFromJson(json);
  
  final String? height;
  final String? time;

  Map<String, Object?> toJson() => _$EntityCurrentHeightStructToJson(this);
}
