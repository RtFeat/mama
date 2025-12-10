// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_single_chat.dart';

part 'moderator_chat_response.g.dart';

@JsonSerializable()
class ModeratorChatResponse {
  const ModeratorChatResponse({
    this.chat,
  });
  
  factory ModeratorChatResponse.fromJson(Map<String, Object?> json) => _$ModeratorChatResponseFromJson(json);
  
  final EntitySingleChat? chat;

  Map<String, Object?> toJson() => _$ModeratorChatResponseToJson(this);
}
