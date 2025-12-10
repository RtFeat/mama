// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_online_school_course.g.dart';

@JsonSerializable()
class EntityOnlineSchoolCourse {
  const EntityOnlineSchoolCourse({
    this.createdAt,
    this.id,
    this.link,
    this.onlineSchoolId,
    this.shortDescription,
    this.title,
  });
  
  factory EntityOnlineSchoolCourse.fromJson(Map<String, Object?> json) => _$EntityOnlineSchoolCourseFromJson(json);
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? link;
  @JsonKey(name: 'online_school_id')
  final String? onlineSchoolId;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  final String? title;

  Map<String, Object?> toJson() => _$EntityOnlineSchoolCourseToJson(this);
}
