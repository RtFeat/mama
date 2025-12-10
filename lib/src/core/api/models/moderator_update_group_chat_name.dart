// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_update_group_chat_name.g.dart';

@JsonSerializable()
class ModeratorUpdateGroupChatName {
  const ModeratorUpdateGroupChatName({
    this.chatId,
    this.newName,
  });
  
  factory ModeratorUpdateGroupChatName.fromJson(Map<String, Object?> json) => _$ModeratorUpdateGroupChatNameFromJson(json);
  
  @JsonKey(name: 'chat_id')
  final String? chatId;
  @JsonKey(name: 'new_name')
  final String? newName;

  Map<String, Object?> toJson() => _$ModeratorUpdateGroupChatNameToJson(this);
}
