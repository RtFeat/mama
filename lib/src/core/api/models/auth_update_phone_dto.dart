// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'auth_update_phone_dto.g.dart';

@JsonSerializable()
class AuthUpdatePhoneDto {
  const AuthUpdatePhoneDto({
    required this.code,
    required this.phone,
  });
  
  factory AuthUpdatePhoneDto.fromJson(Map<String, Object?> json) => _$AuthUpdatePhoneDtoFromJson(json);
  
  final String code;
  final String phone;

  Map<String, Object?> toJson() => _$AuthUpdatePhoneDtoToJson(this);
}
