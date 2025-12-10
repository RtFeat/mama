// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_base_user.dart';
import 'entity_child.dart';

part 'user_me_response.g.dart';

@JsonSerializable()
class UserMeResponse {
  const UserMeResponse({
    this.account,
    this.childs,
    this.user,
  });
  
  factory UserMeResponse.fromJson(Map<String, Object?> json) => _$UserMeResponseFromJson(json);
  
  final EntityAccount? account;
  final List<EntityChild>? childs;
  final EntityBaseUser? user;

  Map<String, Object?> toJson() => _$UserMeResponseToJson(this);
}
