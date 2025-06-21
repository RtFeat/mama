// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'friday.dart';
import 'monday.dart';
import 'saturday.dart';
import 'sunday.dart';
import 'thursday.dart';
import 'tuesday.dart';
import 'wednesday.dart';

part 'doctor_update_work_time.g.dart';

@JsonSerializable()
class DoctorUpdateWorkTime {
  const DoctorUpdateWorkTime({
    this.friday,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
    this.weekStart,
  });
  
  factory DoctorUpdateWorkTime.fromJson(Map<String, Object?> json) => _$DoctorUpdateWorkTimeFromJson(json);
  
  final Friday? friday;
  final Monday? monday;
  final Saturday? saturday;
  final Sunday? sunday;
  final Thursday? thursday;
  final Tuesday? tuesday;
  final Wednesday? wednesday;
  @JsonKey(name: 'week_start')
  final String? weekStart;

  Map<String, Object?> toJson() => _$DoctorUpdateWorkTimeToJson(this);
}
