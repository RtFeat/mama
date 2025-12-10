// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_user_response.dart';

part 'user_list_response.g.dart';

@JsonSerializable()
class UserListResponse {
  const UserListResponse({
    this.users,
  });
  
  factory UserListResponse.fromJson(Map<String, Object?> json) => _$UserListResponseFromJson(json);
  
  final List<EntityUserResponse>? users;

  Map<String, Object?> toJson() => _$UserListResponseToJson(this);
}
