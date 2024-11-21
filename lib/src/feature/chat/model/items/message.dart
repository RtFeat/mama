import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageItem extends BaseModel {
  final String? id;

  @JsonKey(name: 'chat_id')
  final String? chatId;

  @JsonKey(name: 'file_path')
  final String? filePath;

  final String? filename;

  @JsonKey(name: 'nick_name')
  final String? nickname;

  @JsonKey(name: 'read_at')
  final DateTime? readAt;

  @JsonKey(name: 'reply', fromJson: _replyFromJson)
  final dynamic reply;

  static _replyFromJson(value) {
    final isMap = value is Map<String, dynamic>;

    if (isMap) {
      return MessageItem.fromJson(value);
    }

    return value;
  }

  @JsonKey(name: 'files')
  final List<MessageFile>? files;

  @JsonKey(name: 'sender_id')
  final String? senderId;

  final String? text;

  @JsonKey(name: 'type_file')
  final String? typeFile;

  MessageItem({
    this.id,
    this.chatId,
    this.filePath,
    this.filename,
    this.nickname,
    this.readAt,
    this.files,
    this.reply,
    this.senderId,
    this.text,
    this.typeFile,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);

  Map<String, dynamic> toJson() => _$MessageItemToJson(this);
}
