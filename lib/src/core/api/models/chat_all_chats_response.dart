// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_group_chat.dart';
import 'entity_single_chat.dart';

part 'chat_all_chats_response.g.dart';

@JsonSerializable()
class ChatAllChatsResponse {
  const ChatAllChatsResponse({
    this.chats,
    this.groupChat,
  });
  
  factory ChatAllChatsResponse.fromJson(Map<String, Object?> json) => _$ChatAllChatsResponseFromJson(json);
  
  final List<EntitySingleChat>? chats;
  @JsonKey(name: 'group_chat')
  final List<EntityGroupChat>? groupChat;

  Map<String, Object?> toJson() => _$ChatAllChatsResponseToJson(this);
}
