// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'doctor_date.g.dart';

@JsonSerializable()
class DoctorDate {
  const DoctorDate({
    this.date,
  });
  
  factory DoctorDate.fromJson(Map<String, Object?> json) => _$DoctorDateFromJson(json);
  
  final String? date;

  Map<String, Object?> toJson() => _$DoctorDateToJson(this);
}
