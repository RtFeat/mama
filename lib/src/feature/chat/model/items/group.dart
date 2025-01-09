import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'group.g.dart';

@JsonSerializable()
class GroupItem extends _GroupItem with _$GroupItem {
  @JsonKey(name: 'can_delete')
  final bool isCanDelete;

  @JsonKey(name: 'id_group_chat')
  final String? groupChatId;

  @JsonKey(name: 'id_participant')
  final String? participantId;

  @JsonKey(name: 'is_write')
  final bool isWrite;

  @JsonKey(name: 'participant')
  final AccountModel? participant;

  @JsonKey(name: 'group_chat')
  final GroupChatInfo? groupInfo;

  GroupItem({
    this.isCanDelete = false,
    this.groupChatId,
    this.participantId,
    this.isWrite = false,
    this.participant,
    this.groupInfo,
  });

  factory GroupItem.fromJson(Map<String, dynamic> json) =>
      _$GroupItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupItem &&
          runtimeType == other.runtimeType &&
          isCanDelete == other.isCanDelete &&
          groupChatId == other.groupChatId &&
          participantId == other.participantId &&
          isWrite == other.isWrite &&
          participant == other.participant &&
          groupInfo == other.groupInfo;

  @override
  int get hashCode =>
      isCanDelete.hashCode ^
      groupChatId.hashCode ^
      participantId.hashCode ^
      isWrite.hashCode ^
      participant.hashCode ^
      groupInfo.hashCode;
}

abstract class _GroupItem extends ChatItem with Store {
  // _GroupItem({ });
}
