// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_state.dart';

part 'moderator_create_dto.g.dart';

@JsonSerializable()
class ModeratorCreateDto {
  const ModeratorCreateDto({
    this.email,
    this.firstName,
    this.lastName,
    this.name,
    this.phone,
    this.secondName,
    this.specialization,
    this.state,
  });
  
  factory ModeratorCreateDto.fromJson(Map<String, Object?> json) => _$ModeratorCreateDtoFromJson(json);
  
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? name;
  final String? phone;
  @JsonKey(name: 'second_name')
  final String? secondName;
  final String? specialization;
  final EntityState? state;

  Map<String, Object?> toJson() => _$ModeratorCreateDtoToJson(this);
}
