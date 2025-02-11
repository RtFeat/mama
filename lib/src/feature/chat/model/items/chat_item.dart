import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'chat_item.g.dart';

@JsonSerializable()
class ChatItem extends _ChatItem with _$ChatItem {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  ChatItem({
    this.id,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadMessages,
    this.isDeleted = false,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) =>
      _$ChatItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatItemToJson(this);
}

abstract class _ChatItem with Store {
  _ChatItem({
    this.lastMessage,
    this.lastMessageAt,
    this.unreadMessages,
  });

  @observable
  @JsonKey(name: 'last_message')
  MessageItem? lastMessage;

  @action
  void setLastMessage(MessageItem message) => lastMessage = message;

  @observable
  @JsonKey(name: 'last_message_at')
  DateTime? lastMessageAt;

  @action
  void setLastMessageAt(DateTime value) => lastMessageAt = value;

  @observable
  @JsonKey(name: 'unread_messages')
  int? unreadMessages;

  @action
  void setUnreadMessages(int value) => unreadMessages = value;
}
