// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'child_delete_avatar.g.dart';

@JsonSerializable()
class ChildDeleteAvatar {
  const ChildDeleteAvatar({
    required this.childId,
  });
  
  factory ChildDeleteAvatar.fromJson(Map<String, Object?> json) => _$ChildDeleteAvatarFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String childId;

  Map<String, Object?> toJson() => _$ChildDeleteAvatarToJson(this);
}
