// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_message_dto.dart';

part 'entity_message_with_reply.g.dart';

@JsonSerializable()
class EntityMessageWithReply {
  const EntityMessageWithReply({
    this.chatId,
    this.createdAt,
    this.files,
    this.id,
    this.professionId,
    this.readAt,
    this.senderAvatar,
    this.senderId,
    this.senderName,
    this.senderProfession,
    this.senderSurname,
    this.text,
  });
  
  factory EntityMessageWithReply.fromJson(Map<String, Object?> json) => _$EntityMessageWithReplyFromJson(json);
  
  @JsonKey(name: 'chat_id')
  final String? chatId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final List<EntityMessageDto>? files;
  final String? id;
  @JsonKey(name: 'profession_id')
  final String? professionId;
  @JsonKey(name: 'read_at')
  final String? readAt;
  @JsonKey(name: 'sender_avatar')
  final String? senderAvatar;
  @JsonKey(name: 'sender_id')
  final String? senderId;
  @JsonKey(name: 'sender_name')
  final String? senderName;
  @JsonKey(name: 'sender_profession')
  final String? senderProfession;
  @JsonKey(name: 'sender_surname')
  final String? senderSurname;
  final String? text;

  Map<String, Object?> toJson() => _$EntityMessageWithReplyToJson(this);
}
