// @freezed
// class SocketResponse with _$SocketResponse {
//   const SocketResponse._();
//   factory SocketResponse({
//     String? event,
//     @JsonKey(name: 'type_chat') String? typeChat,
//     bool? ok,
//     String? error,
//     SocketDataResponse? data,
//   }) = _SocketResponse;
//   factory SocketResponse.fromJson(Map<String, dynamic> json) => _$SocketResponseFromJson(json);
// }

import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'response.g.dart';

@JsonSerializable()
class SocketResponse {
  final String? event;

  @JsonKey(name: 'type_chat')
  final String? typeChat;

  final bool? ok;
  final String? error;
  final SocketDataResponse? data;

  SocketResponse({
    this.event,
    this.typeChat,
    this.ok,
    this.error,
    this.data,
  });

  factory SocketResponse.fromJson(Map<String, dynamic> json) =>
      _$SocketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocketResponseToJson(this);
}
