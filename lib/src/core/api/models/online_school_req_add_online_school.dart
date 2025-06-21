// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'online_school_req_add_online_school.g.dart';

@JsonSerializable()
class OnlineSchoolReqAddOnlineSchool {
  const OnlineSchoolReqAddOnlineSchool({
    this.link,
    this.onlineSchoolId,
    this.shortDescription,
    this.title,
  });
  
  factory OnlineSchoolReqAddOnlineSchool.fromJson(Map<String, Object?> json) => _$OnlineSchoolReqAddOnlineSchoolFromJson(json);
  
  final String? link;
  @JsonKey(name: 'online_school_id')
  final String? onlineSchoolId;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  final String? title;

  Map<String, Object?> toJson() => _$OnlineSchoolReqAddOnlineSchoolToJson(this);
}
