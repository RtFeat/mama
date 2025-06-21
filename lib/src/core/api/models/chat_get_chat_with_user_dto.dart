// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'chat_get_chat_with_user_dto.g.dart';

@JsonSerializable()
class ChatGetChatWithUserDto {
  const ChatGetChatWithUserDto({
    this.accountId,
  });
  
  factory ChatGetChatWithUserDto.fromJson(Map<String, Object?> json) => _$ChatGetChatWithUserDtoFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;

  Map<String, Object?> toJson() => _$ChatGetChatWithUserDtoToJson(this);
}
