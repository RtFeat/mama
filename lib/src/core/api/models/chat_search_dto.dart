// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'chat_search_dto.g.dart';

@JsonSerializable()
class ChatSearchDto {
  const ChatSearchDto({
    this.chatId,
    this.typeOfChat,
  });
  
  factory ChatSearchDto.fromJson(Map<String, Object?> json) => _$ChatSearchDtoFromJson(json);
  
  @JsonKey(name: 'chat_id')
  final String? chatId;
  @JsonKey(name: 'type_of_chat')
  final String? typeOfChat;

  Map<String, Object?> toJson() => _$ChatSearchDtoToJson(this);
}
