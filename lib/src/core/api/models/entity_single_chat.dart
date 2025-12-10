// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_message.dart';

part 'entity_single_chat.g.dart';

@JsonSerializable()
class EntitySingleChat {
  const EntitySingleChat({
    this.createdAt,
    this.id,
    this.isDeleted,
    this.lastMessage,
    this.lastMessageAt,
    this.participant1Id,
    this.participant1Unread,
    this.participant2Id,
    this.participant2Unread,
    this.participant1,
    this.participant2,
    this.profession,
    this.professionId,
    this.unreadMessages,
  });
  
  factory EntitySingleChat.fromJson(Map<String, Object?> json) => _$EntitySingleChatFromJson(json);
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;
  @JsonKey(name: 'last_message')
  final EntityMessage? lastMessage;
  @JsonKey(name: 'last_message_at')
  final String? lastMessageAt;
  @JsonKey(name: 'participant1_id')
  final String? participant1Id;
  @JsonKey(name: 'participant1_unread')
  final String? participant1Unread;
  @JsonKey(name: 'participant2_id')
  final String? participant2Id;
  @JsonKey(name: 'participant2_unread')
  final String? participant2Unread;
  @JsonKey(name: 'participant_1')
  final EntityAccount? participant1;
  @JsonKey(name: 'participant_2')
  final EntityAccount? participant2;
  final String? profession;
  @JsonKey(name: 'profession_id')
  final String? professionId;
  @JsonKey(name: 'unread_messages')
  final int? unreadMessages;

  Map<String, Object?> toJson() => _$EntitySingleChatToJson(this);
}
