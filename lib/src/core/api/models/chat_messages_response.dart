// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_message_resp.dart';

part 'chat_messages_response.g.dart';

@JsonSerializable()
class ChatMessagesResponse {
  const ChatMessagesResponse({
    this.attached,
    this.messages,
  });
  
  factory ChatMessagesResponse.fromJson(Map<String, Object?> json) => _$ChatMessagesResponseFromJson(json);
  
  final List<String>? attached;
  final List<EntityMessageResp>? messages;

  Map<String, Object?> toJson() => _$ChatMessagesResponseToJson(this);
}
