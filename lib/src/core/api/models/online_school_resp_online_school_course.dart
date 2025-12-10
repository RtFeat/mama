// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_online_school_course.dart';

part 'online_school_resp_online_school_course.g.dart';

@JsonSerializable()
class OnlineSchoolRespOnlineSchoolCourse {
  const OnlineSchoolRespOnlineSchoolCourse({
    this.list,
  });
  
  factory OnlineSchoolRespOnlineSchoolCourse.fromJson(Map<String, Object?> json) => _$OnlineSchoolRespOnlineSchoolCourseFromJson(json);
  
  final List<EntityOnlineSchoolCourse>? list;

  Map<String, Object?> toJson() => _$OnlineSchoolRespOnlineSchoolCourseToJson(this);
}
