// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_message.g.dart';

@JsonSerializable()
class EntityMessage {
  const EntityMessage({
    this.chatId,
    this.createdAt,
    this.filePath,
    this.filename,
    this.id,
    this.nickName,
    this.readAt,
    this.reply,
    this.senderId,
    this.text,
    this.typeFile,
  });
  
  factory EntityMessage.fromJson(Map<String, Object?> json) => _$EntityMessageFromJson(json);
  
  @JsonKey(name: 'chat_id')
  final String? chatId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'file_path')
  final String? filePath;
  final String? filename;
  final String? id;
  @JsonKey(name: 'nick_name')
  final String? nickName;
  @JsonKey(name: 'read_at')
  final String? readAt;
  final String? reply;
  @JsonKey(name: 'sender_id')
  final String? senderId;
  final String? text;
  @JsonKey(name: 'type_file')
  final String? typeFile;

  Map<String, Object?> toJson() => _$EntityMessageToJson(this);
}
