// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';

part 'chat_response_get_all_users_in_chats.g.dart';

@JsonSerializable()
class ChatResponseGetAllUsersInChats {
  const ChatResponseGetAllUsersInChats({
    this.users,
  });
  
  factory ChatResponseGetAllUsersInChats.fromJson(Map<String, Object?> json) => _$ChatResponseGetAllUsersInChatsFromJson(json);
  
  final List<EntityAccount>? users;

  Map<String, Object?> toJson() => _$ChatResponseGetAllUsersInChatsToJson(this);
}
