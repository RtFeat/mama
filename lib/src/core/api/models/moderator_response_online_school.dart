// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_online_school_response.dart';

part 'moderator_response_online_school.g.dart';

@JsonSerializable()
class ModeratorResponseOnlineSchool {
  const ModeratorResponseOnlineSchool({
    this.onlineSchool,
  });
  
  factory ModeratorResponseOnlineSchool.fromJson(Map<String, Object?> json) => _$ModeratorResponseOnlineSchoolFromJson(json);
  
  @JsonKey(name: 'online_school')
  final EntityOnlineSchoolResponse? onlineSchool;

  Map<String, Object?> toJson() => _$ModeratorResponseOnlineSchoolToJson(this);
}
