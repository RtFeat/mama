// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_message_resp.dart';

part 'chat_file_response.g.dart';

@JsonSerializable()
class ChatFileResponse {
  const ChatFileResponse({
    this.message,
  });
  
  factory ChatFileResponse.fromJson(Map<String, Object?> json) => _$ChatFileResponseFromJson(json);
  
  final EntityMessageResp? message;

  Map<String, Object?> toJson() => _$ChatFileResponseToJson(this);
}
