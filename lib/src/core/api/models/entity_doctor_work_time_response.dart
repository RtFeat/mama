// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'friday2.dart';
import 'monday2.dart';
import 'saturday2.dart';
import 'sunday2.dart';
import 'thursday2.dart';
import 'tuesday2.dart';
import 'wednesday2.dart';

part 'entity_doctor_work_time_response.g.dart';

@JsonSerializable()
class EntityDoctorWorkTimeResponse {
  const EntityDoctorWorkTimeResponse({
    this.accountId,
    this.friday,
    this.id,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
    this.weekStart,
  });
  
  factory EntityDoctorWorkTimeResponse.fromJson(Map<String, Object?> json) => _$EntityDoctorWorkTimeResponseFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  final Friday2? friday;
  final String? id;
  final Monday2? monday;
  final Saturday2? saturday;
  final Sunday2? sunday;
  final Thursday2? thursday;
  final Tuesday2? tuesday;
  final Wednesday2? wednesday;
  @JsonKey(name: 'week_start')
  final String? weekStart;

  Map<String, Object?> toJson() => _$EntityDoctorWorkTimeResponseToJson(this);
}
