// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_online_school_response.dart';

part 'online_school_response_online_school.g.dart';

@JsonSerializable()
class OnlineSchoolResponseOnlineSchool {
  const OnlineSchoolResponseOnlineSchool({
    this.onlineSchool,
  });
  
  factory OnlineSchoolResponseOnlineSchool.fromJson(Map<String, Object?> json) => _$OnlineSchoolResponseOnlineSchoolFromJson(json);
  
  @JsonKey(name: 'online_school')
  final EntityOnlineSchoolResponse? onlineSchool;

  Map<String, Object?> toJson() => _$OnlineSchoolResponseOnlineSchoolToJson(this);
}
