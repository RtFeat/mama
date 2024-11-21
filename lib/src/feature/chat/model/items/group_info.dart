import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'group_info.g.dart';

@JsonSerializable()
class GroupChatInfo extends _GroupChatInfo with _$GroupChatInfo {
  @JsonKey(name: 'avatar')
  final String? avatarUrl;

  @JsonKey(name: 'group_chat')
  final String? groupChat;

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  GroupChatInfo({this.avatarUrl, this.groupChat, this.id, this.name});

  factory GroupChatInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupChatInfoToJson(this);
}

abstract class _GroupChatInfo with Store {}
