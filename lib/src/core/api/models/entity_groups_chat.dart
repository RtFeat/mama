// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_groups_chat.g.dart';

@JsonSerializable()
class EntityGroupsChat {
  const EntityGroupsChat({
    this.avatar,
    this.groupChat,
    this.id,
    this.name,
    this.numberOfOnlineUsers,
    this.numberOfSpecialists,
    this.numberOfUsers,
  });
  
  factory EntityGroupsChat.fromJson(Map<String, Object?> json) => _$EntityGroupsChatFromJson(json);
  
  final String? avatar;
  @JsonKey(name: 'group_chat')
  final String? groupChat;
  final String? id;
  final String? name;
  @JsonKey(name: 'number_of_online_users')
  final int? numberOfOnlineUsers;
  @JsonKey(name: 'number_of_specialists')
  final int? numberOfSpecialists;
  @JsonKey(name: 'number_of_users')
  final int? numberOfUsers;

  Map<String, Object?> toJson() => _$EntityGroupsChatToJson(this);
}
