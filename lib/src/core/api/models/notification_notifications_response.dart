// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_notification.dart';

part 'notification_notifications_response.g.dart';

@JsonSerializable()
class NotificationNotificationsResponse {
  const NotificationNotificationsResponse({
    this.notifications,
  });
  
  factory NotificationNotificationsResponse.fromJson(Map<String, Object?> json) => _$NotificationNotificationsResponseFromJson(json);
  
  final List<EntityNotification>? notifications;

  Map<String, Object?> toJson() => _$NotificationNotificationsResponseToJson(this);
}
