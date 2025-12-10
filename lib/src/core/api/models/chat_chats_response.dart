// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_single_chat.dart';

part 'chat_chats_response.g.dart';

@JsonSerializable()
class ChatChatsResponse {
  const ChatChatsResponse({
    this.chats,
  });
  
  factory ChatChatsResponse.fromJson(Map<String, Object?> json) => _$ChatChatsResponseFromJson(json);
  
  final List<EntitySingleChat>? chats;

  Map<String, Object?> toJson() => _$ChatChatsResponseToJson(this);
}
