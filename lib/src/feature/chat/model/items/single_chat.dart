import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'single_chat.g.dart';

@JsonSerializable()
class SingleChatItem extends _SingleChatItem with _$SingleChatItem {
  @JsonKey(name: 'participant1_id')
  final String? participant1Id;

  @JsonKey(name: 'participant1_unread')
  final String? participant1Unread;

  @JsonKey(name: 'participant2_id')
  final String? participant2Id;

  @JsonKey(name: 'participant2_unread')
  final String? participant2Unread;

  @JsonKey(name: 'participant_1')
  final AccountModel? participant1;

  @JsonKey(name: 'participant_2')
  final AccountModel? participant2;

  final String? profession;

  @JsonKey(name: 'profession_id')
  final String? professionId;

  SingleChatItem({
    this.participant1Id,
    this.participant1Unread,
    this.participant2Id,
    this.participant2Unread,
    this.participant1,
    this.participant2,
    this.profession,
    this.professionId,
    super.id,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadMessages,
  });

  factory SingleChatItem.fromJson(Map<String, dynamic> json) =>
      _$SingleChatItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SingleChatItemToJson(this);

  @override
  bool operator ==(Object other) =>
      other is SingleChatItem &&
      other.id == id &&
      other.lastMessage == lastMessage;

  @override
  int get hashCode => id.hashCode;
}

abstract class _SingleChatItem extends ChatItem with Store {
  _SingleChatItem({
    super.id,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadMessages,
  });
}
