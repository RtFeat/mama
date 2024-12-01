import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'course.g.dart';

@JsonSerializable()
class OnlineSchoolCourse extends BaseModel {
  final String? id;
  final String? link;

  @JsonKey(name: 'online_school_id')
  final String? onlineSchoolId;

  @JsonKey(name: 'short_description')
  final String? shortDescription;

  final String? title;

  OnlineSchoolCourse({
    this.id,
    this.link,
    this.onlineSchoolId,
    this.shortDescription,
    this.title,
  });

  factory OnlineSchoolCourse.fromJson(Map<String, dynamic> json) =>
      _$OnlineSchoolCourseFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineSchoolCourseToJson(this);
}
