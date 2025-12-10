// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'online_school_update_online_course_dto.g.dart';

@JsonSerializable()
class OnlineSchoolUpdateOnlineCourseDto {
  const OnlineSchoolUpdateOnlineCourseDto({
    this.id,
    this.link,
    this.shortDescription,
    this.title,
  });
  
  factory OnlineSchoolUpdateOnlineCourseDto.fromJson(Map<String, Object?> json) => _$OnlineSchoolUpdateOnlineCourseDtoFromJson(json);
  
  final String? id;
  final String? link;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  final String? title;

  Map<String, Object?> toJson() => _$OnlineSchoolUpdateOnlineCourseDtoToJson(this);
}
