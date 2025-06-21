// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'child_update_dto.g.dart';

@JsonSerializable()
class ChildUpdateDto {
  const ChildUpdateDto({
    required this.birthDate,
    required this.id,
    this.childbirth,
    this.childbirthWithComplications,
    this.firstName,
    this.gender,
    this.headCirc,
    this.height,
    this.info,
    this.isTwins,
    this.secondName,
    this.weight,
  });
  
  factory ChildUpdateDto.fromJson(Map<String, Object?> json) => _$ChildUpdateDtoFromJson(json);
  
  @JsonKey(name: 'birth_date')
  final String birthDate;
  final String? childbirth;
  @JsonKey(name: 'childbirth_with_complications')
  final bool? childbirthWithComplications;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final String? gender;
  @JsonKey(name: 'head_circ')
  final num? headCirc;
  final num? height;
  final String id;
  final String? info;
  @JsonKey(name: 'is_twins')
  final bool? isTwins;
  @JsonKey(name: 'second_name')
  final String? secondName;
  final num? weight;

  Map<String, Object?> toJson() => _$ChildUpdateDtoToJson(this);
}
