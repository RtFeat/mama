// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_single_chat.dart';

part 'chat_chat_response.g.dart';

@JsonSerializable()
class ChatChatResponse {
  const ChatChatResponse({
    this.chat,
  });
  
  factory ChatChatResponse.fromJson(Map<String, Object?> json) => _$ChatChatResponseFromJson(json);
  
  final EntitySingleChat? chat;

  Map<String, Object?> toJson() => _$ChatChatResponseToJson(this);
}
