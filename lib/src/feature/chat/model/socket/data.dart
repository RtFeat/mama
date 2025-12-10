// class SocketDataResponse with _$SocketDataResponse {
//   const SocketDataResponse._();
//   factory SocketDataResponse({
//     Message? message,
//     @JsonKey(name: 'chat_id') String? chatId,
//     @JsonKey(name: 'message_id') String? messageId,
//   }) = _SocketDataResponse;
//   factory SocketDataResponse.fromJson(Map<String, dynamic> json) =>
//       _$SocketDataResponseFromJson(json);
// // }

import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'data.g.dart';

@JsonSerializable()
class SocketDataResponse {
  final MessageItem? message;

  @JsonKey(name: 'chat_id')
  final String? chatId;

  @JsonKey(name: 'message_id')
  final String? messageId;

  SocketDataResponse({
    this.message,
    this.chatId,
    this.messageId,
  });

  factory SocketDataResponse.fromJson(Map<String, dynamic> json) =>
      _$SocketDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocketDataResponseToJson(this);
}
