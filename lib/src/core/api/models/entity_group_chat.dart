// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_groups_chat.dart';
import 'entity_message.dart';

part 'entity_group_chat.g.dart';

@JsonSerializable()
class EntityGroupChat {
  const EntityGroupChat({
    this.canDelete,
    this.createdAt,
    this.groupChat,
    this.id,
    this.idGroupChat,
    this.idParticipant,
    this.isDeleted,
    this.isWrite,
    this.lastMessage,
    this.lastMessageAt,
    this.participant,
    this.unreadMessages,
    this.updatedAt,
  });
  
  factory EntityGroupChat.fromJson(Map<String, Object?> json) => _$EntityGroupChatFromJson(json);
  
  @JsonKey(name: 'can_delete')
  final bool? canDelete;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'group_chat')
  final EntityGroupsChat? groupChat;
  final String? id;
  @JsonKey(name: 'id_group_chat')
  final String? idGroupChat;
  @JsonKey(name: 'id_participant')
  final String? idParticipant;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;
  @JsonKey(name: 'is_write')
  final bool? isWrite;
  @JsonKey(name: 'last_message')
  final EntityMessage? lastMessage;
  @JsonKey(name: 'last_message_at')
  final String? lastMessageAt;
  final EntityAccount? participant;
  @JsonKey(name: 'unread_messages')
  final int? unreadMessages;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityGroupChatToJson(this);
}
