// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_message_resp.dart';

part 'chat_search_in_chat_resp.g.dart';

@JsonSerializable()
class ChatSearchInChatResp {
  const ChatSearchInChatResp({
    this.message,
  });
  
  factory ChatSearchInChatResp.fromJson(Map<String, Object?> json) => _$ChatSearchInChatRespFromJson(json);
  
  final List<EntityMessageResp>? message;

  Map<String, Object?> toJson() => _$ChatSearchInChatRespToJson(this);
}
