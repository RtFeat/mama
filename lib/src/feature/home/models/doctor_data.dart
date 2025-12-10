import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

part 'doctor_data.g.dart';

@JsonSerializable()
class DoctorData extends SkitBaseModel {
  final DoctorModel? doctor;
  DoctorData({this.doctor});

  factory DoctorData.fromJson(Map<String, dynamic> json) =>
      _$DoctorDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DoctorDataToJson(this);
}
