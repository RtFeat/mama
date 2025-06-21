// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_insert_users_to_chat.g.dart';

@JsonSerializable()
class ModeratorInsertUsersToChat {
  const ModeratorInsertUsersToChat({
    this.idGroupChat,
    this.idsUsers,
  });
  
  factory ModeratorInsertUsersToChat.fromJson(Map<String, Object?> json) => _$ModeratorInsertUsersToChatFromJson(json);
  
  @JsonKey(name: 'id_group_chat')
  final String? idGroupChat;
  @JsonKey(name: 'ids_users')
  final List<String>? idsUsers;

  Map<String, Object?> toJson() => _$ModeratorInsertUsersToChatToJson(this);
}
