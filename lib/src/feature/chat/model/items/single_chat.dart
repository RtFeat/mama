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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SingleChatItem &&
        other.participant1Id == participant1Id &&
        other.participant1Unread == participant1Unread &&
        other.participant2Id == participant2Id &&
        other.participant2Unread == participant2Unread &&
        other.participant1 == participant1 &&
        other.participant2 == participant2 &&
        other.profession == profession &&
        other.professionId == professionId &&
        other.lastMessage == lastMessage &&
        other.lastMessageAt == lastMessageAt &&
        other.unreadMessages == unreadMessages;
  }

  @override
  int get hashCode {
    return participant1Id.hashCode ^
        participant1Unread.hashCode ^
        participant2Id.hashCode ^
        participant2Unread.hashCode ^
        participant1.hashCode ^
        participant2.hashCode ^
        profession.hashCode ^
        professionId.hashCode ^
        lastMessage.hashCode ^
        lastMessageAt.hashCode ^
        unreadMessages.hashCode;
  }
}

abstract class _SingleChatItem extends ChatItem with Store {
  _SingleChatItem({
    super.id,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadMessages,
  });
}
