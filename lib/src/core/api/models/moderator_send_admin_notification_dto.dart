// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_send_admin_notification_dto.g.dart';

@JsonSerializable()
class ModeratorSendAdminNotificationDto {
  const ModeratorSendAdminNotificationDto({
    this.text,
    this.userId,
  });
  
  factory ModeratorSendAdminNotificationDto.fromJson(Map<String, Object?> json) => _$ModeratorSendAdminNotificationDtoFromJson(json);
  
  final String? text;
  @JsonKey(name: 'user_id')
  final String? userId;

  Map<String, Object?> toJson() => _$ModeratorSendAdminNotificationDtoToJson(this);
}
