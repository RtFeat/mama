// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_base_user.dart';
import 'entity_child.dart';

part 'entity_user_response.g.dart';

@JsonSerializable()
class EntityUserResponse {
  const EntityUserResponse({
    this.account,
    this.childs,
    this.user,
  });
  
  factory EntityUserResponse.fromJson(Map<String, Object?> json) => _$EntityUserResponseFromJson(json);
  
  final EntityAccount? account;
  final List<EntityChild>? childs;
  final EntityBaseUser? user;

  Map<String, Object?> toJson() => _$EntityUserResponseToJson(this);
}
