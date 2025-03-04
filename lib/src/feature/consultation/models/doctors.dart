import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

part 'doctors.g.dart';

@JsonSerializable()
class Doctors extends SkitBaseModel {
  @JsonKey(name: 'doctors')
  final List<DoctorModel>? data;

  Doctors({this.data});

  factory Doctors.fromJson(Map<String, dynamic> json) =>
      _$DoctorsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DoctorsToJson(this);
}
