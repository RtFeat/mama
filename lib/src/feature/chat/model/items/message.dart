import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'message.g.dart';

// @JsonSerializable()
// class MessageItem extends BaseModel {
//   final String? id;

//   @JsonKey(name: 'chat_id')
//   final String? chatId;

//   @JsonKey(name: 'file_path')
//   final String? filePath;

//   final String? filename;

//   @JsonKey(name: 'nick_name')
//   final String? nickname;

//   @JsonKey(name: 'read_at')
//   final DateTime? readAt;

//   @JsonKey(name: 'reply', fromJson: _replyFromJson)
//   final dynamic reply;

//   static _replyFromJson(value) {
//     final isMap = value is Map<String, dynamic>;

//     if (isMap) {
//       return MessageItem.fromJson(value);
//     }

//     return value;
//   }

//   @JsonKey(name: 'files')
//   final List<MessageFile>? files;

//   @JsonKey(name: 'sender_id')
//   final String? senderId;

//   final String? text;

//   @JsonKey(name: 'type_file')
//   final String? typeFile;

//   MessageItem({
//     this.id,
//     this.chatId,
//     this.filePath,
//     this.filename,
//     this.nickname,
//     this.readAt,
//     this.files,
//     this.reply,
//     this.senderId,
//     this.text,
//     this.typeFile,
//     super.createdAt,
//     super.updatedAt,
//   });

//   factory MessageItem.fromJson(Map<String, dynamic> json) =>
//       _$MessageItemFromJson(json);

//   Map<String, dynamic> toJson() => _$MessageItemToJson(this);
// }

@JsonSerializable()
class MessageItem extends _MessageItem with _$MessageItem {
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

  @JsonKey(name: 'sender_id')
  final String? senderId;

  final String? text;

  @JsonKey(name: 'sender_avatar')
  final String? senderAvatarUrl;

  @JsonKey(name: 'sender_name')
  final String? senderName;

  @JsonKey(name: 'sender_surname')
  final String? senderSurname;

  @JsonKey(name: 'sender_profession')
  final String? senderProfession;

  @JsonKey(name: 'type_file')
  final String? typeFile;

  MessageItem({
    this.id,
    this.chatId,
    this.filePath,
    this.filename,
    this.nickname,
    this.readAt,
    super.files,
    super.reply,
    this.senderAvatarUrl,
    this.senderName,
    this.senderSurname,
    this.senderProfession,
    this.senderId,
    this.text,
    this.typeFile,
    super.createdAt,
    super.updatedAt,
    super.isAttached,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageItemToJson(this);

  MessageItem copyWith({
    String? id,
    String? chatId,
    String? filePath,
    String? filename,
    String? nickname,
    DateTime? readAt,
    ObservableList<MessageFile>? files,
    dynamic reply,
    String? senderId,
    String? senderAvatarUrl,
    String? senderName,
    String? senderSurname,
    String? senderProfession,
    String? text,
    String? typeFile,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAttached,
  }) =>
      MessageItem(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        filePath: filePath ?? this.filePath,
        filename: filename ?? this.filename,
        nickname: nickname ?? this.nickname,
        readAt: readAt ?? this.readAt,
        files: files ?? this.files,
        reply: reply ?? this.reply,
        senderId: senderId ?? this.senderId,
        senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
        senderName: senderName ?? this.senderName,
        senderSurname: senderSurname ?? this.senderSurname,
        senderProfession: senderProfession ?? this.senderProfession,
        text: text ?? this.text,
        typeFile: typeFile ?? this.typeFile,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isAttached: isAttached ?? this.isAttached,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          chatId == other.chatId &&
          filePath == other.filePath &&
          filename == other.filename &&
          nickname == other.nickname &&
          readAt == other.readAt &&
          files == other.files &&
          reply == other.reply &&
          senderId == other.senderId &&
          senderAvatarUrl == other.senderAvatarUrl &&
          senderName == other.senderName &&
          senderSurname == other.senderSurname &&
          senderProfession == other.senderProfession &&
          text == other.text &&
          typeFile == other.typeFile &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          isAttached == other.isAttached;

  @override
  int get hashCode =>
      id.hashCode ^
      chatId.hashCode ^
      filePath.hashCode ^
      filename.hashCode ^
      nickname.hashCode ^
      readAt.hashCode ^
      files.hashCode ^
      reply.hashCode ^
      senderId.hashCode ^
      senderAvatarUrl.hashCode ^
      senderName.hashCode ^
      senderSurname.hashCode ^
      senderProfession.hashCode ^
      text.hashCode ^
      typeFile.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isAttached.hashCode;
}

abstract class _MessageItem extends BaseModel with Store {
  _MessageItem({
    required super.createdAt,
    required super.updatedAt,
    this.files,
    this.reply,
    this.isAttached = false,
  });

  @JsonKey(name: 'files', fromJson: _filesFromJson, toJson: _filesToJson)
  @observable
  ObservableList<MessageFile>? files;

  static List<MessageFile> _filesToJson(v) {
    return v.toList();
  }

  static ObservableList<MessageFile> _filesFromJson(List? v) {
    final workSlots = v?.map((e) => MessageFile.fromJson(e)).toList();
    return ObservableList.of(workSlots ?? []);
  }

  @computed
  bool get hasVoice =>
      files?.where((e) => e.typeFile == 'm4a').isNotEmpty ?? false;

  @JsonKey(name: 'reply', fromJson: _replyFromJson)
  dynamic reply;

  static _replyFromJson(value) {
    final isMap = value is Map<String, dynamic>;

    if (isMap) {
      return MessageItem.fromJson(value);
    }

    return value;
  }

  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isAttached = false;

  @action
  void setIsAttached(bool value) => isAttached = value;
}
