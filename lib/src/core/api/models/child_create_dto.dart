// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'child_create_dto.g.dart';

@JsonSerializable()
class ChildCreateDto {
  const ChildCreateDto({
    required this.birthDate,
    required this.firstName,
    required this.headCirc,
    required this.height,
    required this.weight,
    this.childbirth,
    this.childbirthWithComplications,
    this.gender,
    this.info,
    this.isTwins,
    this.secondName,
  });
  
  factory ChildCreateDto.fromJson(Map<String, Object?> json) => _$ChildCreateDtoFromJson(json);
  
  @JsonKey(name: 'birth_date')
  final String birthDate;
  final String? childbirth;
  @JsonKey(name: 'childbirth_with_complications')
  final bool? childbirthWithComplications;
  @JsonKey(name: 'first_name')
  final String firstName;
  final String? gender;
  @JsonKey(name: 'head_circ')
  final num headCirc;
  final num height;
  final String? info;
  @JsonKey(name: 'is_twins')
  final bool? isTwins;
  @JsonKey(name: 'second_name')
  final String? secondName;
  final num weight;

  Map<String, Object?> toJson() => _$ChildCreateDtoToJson(this);
}
