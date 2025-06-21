// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_role.dart';
import 'entity_single_chat.dart';
import 'entity_status.dart';
import 'entity_user_response.dart';

part 'auth_sign_up_response.g.dart';

@JsonSerializable()
class AuthSignUpResponse {
  const AuthSignUpResponse({
    this.accessToken,
    this.account,
    this.chat,
    this.role,
    this.status,
  });
  
  factory AuthSignUpResponse.fromJson(Map<String, Object?> json) => _$AuthSignUpResponseFromJson(json);
  
  @JsonKey(name: 'access_token')
  final String? accessToken;
  final EntityUserResponse? account;
  final EntitySingleChat? chat;
  final EntityRole? role;
  final EntityStatus? status;

  Map<String, Object?> toJson() => _$AuthSignUpResponseToJson(this);
}
