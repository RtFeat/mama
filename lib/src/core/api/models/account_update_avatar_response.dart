// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'account_update_avatar_response.g.dart';

@JsonSerializable()
class AccountUpdateAvatarResponse {
  const AccountUpdateAvatarResponse({
    this.avatar,
  });
  
  factory AccountUpdateAvatarResponse.fromJson(Map<String, Object?> json) => _$AccountUpdateAvatarResponseFromJson(json);
  
  final String? avatar;

  Map<String, Object?> toJson() => _$AccountUpdateAvatarResponseToJson(this);
}
