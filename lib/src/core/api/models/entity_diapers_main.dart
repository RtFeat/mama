// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_diapers_sub_main.dart';

part 'entity_diapers_main.g.dart';

@JsonSerializable()
class EntityDiapersMain {
  const EntityDiapersMain({
    this.data,
    this.diapersSub,
  });
  
  factory EntityDiapersMain.fromJson(Map<String, Object?> json) => _$EntityDiapersMainFromJson(json);
  
  final String? data;
  @JsonKey(name: 'diapers_sub')
  final List<EntityDiapersSubMain>? diapersSub;

  Map<String, Object?> toJson() => _$EntityDiapersMainToJson(this);
}
