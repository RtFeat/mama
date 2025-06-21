// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_single_chat.dart';

part 'feedback_chat_response.g.dart';

@JsonSerializable()
class FeedbackChatResponse {
  const FeedbackChatResponse({
    this.chat,
  });
  
  factory FeedbackChatResponse.fromJson(Map<String, Object?> json) => _$FeedbackChatResponseFromJson(json);
  
  final EntitySingleChat? chat;

  Map<String, Object?> toJson() => _$FeedbackChatResponseToJson(this);
}
