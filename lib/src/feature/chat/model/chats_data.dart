import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'chats_data.g.dart';

@JsonSerializable()
class ChatsData {
  @JsonKey(name: 'chats')
  final List<SingleChatItem>? chats;

  @JsonKey(name: 'group_chat')
  final List<GroupItem>? groups;

  ChatsData({this.chats, this.groups});

  factory ChatsData.fromJson(Map<String, dynamic> json) =>
      _$ChatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsDataToJson(this);
}
