// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'notification_delete_dto.g.dart';

@JsonSerializable()
class NotificationDeleteDto {
  const NotificationDeleteDto({
    this.id,
  });
  
  factory NotificationDeleteDto.fromJson(Map<String, Object?> json) => _$NotificationDeleteDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$NotificationDeleteDtoToJson(this);
}
