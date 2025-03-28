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

  @JsonKey(name: 'number_of_specialists')
  final int? numberOfSpecialists;

  @JsonKey(name: 'number_of_users')
  final int? numberOfUsers;

  @JsonKey(name: 'number_of_online_users')
  final int? numberOfOnlineUsers;

  GroupChatInfo({
    this.avatarUrl,
    this.groupChat,
    this.id,
    this.name,
    this.numberOfSpecialists,
    this.numberOfUsers,
    this.numberOfOnlineUsers,
  });

  factory GroupChatInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupChatInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupChatInfoToJson(this);

  @override
  String toString() =>
      'GroupChatInfo(avatarUrl: $avatarUrl, groupChat: $groupChat, id: $id, name: $name, numberOfSpecialists: $numberOfSpecialists, numberOfUsers: $numberOfUsers, numberOfOnlineUsers: $numberOfOnlineUsers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupChatInfo &&
        other.avatarUrl == avatarUrl &&
        other.groupChat == groupChat &&
        other.id == id &&
        other.name == name &&
        other.numberOfSpecialists == numberOfSpecialists &&
        other.numberOfUsers == numberOfUsers &&
        other.numberOfOnlineUsers == numberOfOnlineUsers;
  }

  @override
  int get hashCode =>
      avatarUrl.hashCode ^
      groupChat.hashCode ^
      id.hashCode ^
      name.hashCode ^
      numberOfSpecialists.hashCode ^
      numberOfUsers.hashCode ^
      numberOfOnlineUsers.hashCode;
}

abstract class _GroupChatInfo with Store {}
