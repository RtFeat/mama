// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'child_update_avatar_response.g.dart';

@JsonSerializable()
class ChildUpdateAvatarResponse {
  const ChildUpdateAvatarResponse({
    this.avatar,
  });
  
  factory ChildUpdateAvatarResponse.fromJson(Map<String, Object?> json) => _$ChildUpdateAvatarResponseFromJson(json);
  
  final String? avatar;

  Map<String, Object?> toJson() => _$ChildUpdateAvatarResponseToJson(this);
}
