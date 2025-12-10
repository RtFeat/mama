// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_notification.g.dart';

@JsonSerializable()
class EntityNotification {
  const EntityNotification({
    this.createdAt,
    this.id,
    this.metadata,
    this.read,
    this.text,
    this.type,
    this.userId,
  });
  
  factory EntityNotification.fromJson(Map<String, Object?> json) => _$EntityNotificationFromJson(json);
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final dynamic metadata;
  final bool? read;
  final String? text;
  final String? type;
  @JsonKey(name: 'user_id')
  final String? userId;

  Map<String, Object?> toJson() => _$EntityNotificationToJson(this);
}
