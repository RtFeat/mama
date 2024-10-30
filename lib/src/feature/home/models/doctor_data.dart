import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'doctor_data.g.dart';

@JsonSerializable()
class DoctorData {
  final DoctorModel? doctor;
  DoctorData({this.doctor});

  factory DoctorData.fromJson(Map<String, dynamic> json) =>
      _$DoctorDataFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDataToJson(this);
}
