// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_update_dto.g.dart';

@JsonSerializable()
class UserUpdateDto {
  const UserUpdateDto({
    this.city,
    this.email,
    this.firstName,
    this.gender,
    this.info,
    this.lastName,
    this.roles,
    this.secondName,
  });
  
  factory UserUpdateDto.fromJson(Map<String, Object?> json) => _$UserUpdateDtoFromJson(json);
  
  final String? city;
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final String? gender;
  final String? info;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final List<String>? roles;
  @JsonKey(name: 'second_name')
  final String? secondName;

  Map<String, Object?> toJson() => _$UserUpdateDtoToJson(this);
}
