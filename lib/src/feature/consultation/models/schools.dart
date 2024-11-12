import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'schools.g.dart';

@JsonSerializable()
class Schools {
  @JsonKey(name: 'online_school')
  final List<SchoolModel>? schools;

  Schools({required this.schools});

  factory Schools.fromJson(Map<String, dynamic> json) =>
      _$SchoolsFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolsToJson(this);
}
