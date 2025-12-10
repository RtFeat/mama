// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_message_dto.dart';

part 'chat_upload_response.g.dart';

@JsonSerializable()
class ChatUploadResponse {
  const ChatUploadResponse({
    this.messages,
  });
  
  factory ChatUploadResponse.fromJson(Map<String, Object?> json) => _$ChatUploadResponseFromJson(json);
  
  final List<EntityMessageDto>? messages;

  Map<String, Object?> toJson() => _$ChatUploadResponseToJson(this);
}
