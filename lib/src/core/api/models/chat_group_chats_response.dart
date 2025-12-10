// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_group_chat.dart';

part 'chat_group_chats_response.g.dart';

@JsonSerializable()
class ChatGroupChatsResponse {
  const ChatGroupChatsResponse({
    this.chats,
  });
  
  factory ChatGroupChatsResponse.fromJson(Map<String, Object?> json) => _$ChatGroupChatsResponseFromJson(json);
  
  final List<EntityGroupChat>? chats;

  Map<String, Object?> toJson() => _$ChatGroupChatsResponseToJson(this);
}
