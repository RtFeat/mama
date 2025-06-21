// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_diapers_sub_main.g.dart';

@JsonSerializable()
class EntityDiapersSubMain {
  const EntityDiapersSubMain({
    this.howMuch,
    this.notes,
    this.time,
    this.typeOfDiapers,
  });
  
  factory EntityDiapersSubMain.fromJson(Map<String, Object?> json) => _$EntityDiapersSubMainFromJson(json);
  
  @JsonKey(name: 'how_much')
  final String? howMuch;
  final String? notes;
  final String? time;
  @JsonKey(name: 'type_of_diapers')
  final String? typeOfDiapers;

  Map<String, Object?> toJson() => _$EntityDiapersSubMainToJson(this);
}
