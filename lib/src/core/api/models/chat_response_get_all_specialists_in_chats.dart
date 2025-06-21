// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account_me.dart';

part 'chat_response_get_all_specialists_in_chats.g.dart';

@JsonSerializable()
class ChatResponseGetAllSpecialistsInChats {
  const ChatResponseGetAllSpecialistsInChats({
    this.specialists,
  });
  
  factory ChatResponseGetAllSpecialistsInChats.fromJson(Map<String, Object?> json) => _$ChatResponseGetAllSpecialistsInChatsFromJson(json);
  
  final List<EntityAccountMe>? specialists;

  Map<String, Object?> toJson() => _$ChatResponseGetAllSpecialistsInChatsToJson(this);
}
