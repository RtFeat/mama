// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_childbirth.dart';
import 'entity_status_of_child.dart';

part 'entity_child.g.dart';

@JsonSerializable()
class EntityChild {
  const EntityChild({
    this.avatar,
    this.birthDate,
    this.childbirth,
    this.childbirthWithComplications,
    this.createdAt,
    this.firstName,
    this.gender,
    this.headCirc,
    this.height,
    this.id,
    this.info,
    this.isTwins,
    this.secondName,
    this.status,
    this.updatedAt,
    this.weight,
  });
  
  factory EntityChild.fromJson(Map<String, Object?> json) => _$EntityChildFromJson(json);
  
  final String? avatar;
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  final EntityChildbirth? childbirth;
  @JsonKey(name: 'childbirth_with_complications')
  final bool? childbirthWithComplications;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final String? gender;
  @JsonKey(name: 'head_circ')
  final num? headCirc;
  final num? height;
  final String? id;
  final String? info;
  @JsonKey(name: 'is_twins')
  final bool? isTwins;
  @JsonKey(name: 'second_name')
  final String? secondName;
  final EntityStatusOfChild? status;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final num? weight;

  Map<String, Object?> toJson() => _$EntityChildToJson(this);
}
