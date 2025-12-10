// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_chats_dto.g.dart';

@JsonSerializable()
class ModeratorChatsDto {
  const ModeratorChatsDto({
    this.accountId,
  });
  
  factory ModeratorChatsDto.fromJson(Map<String, Object?> json) => _$ModeratorChatsDtoFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;

  Map<String, Object?> toJson() => _$ModeratorChatsDtoToJson(this);
}
