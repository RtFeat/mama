// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_doctor_work_time_response.dart';

part 'entity_doctor_response.g.dart';

@JsonSerializable()
class EntityDoctorResponse {
  const EntityDoctorResponse({
    this.account,
    this.countArticles,
    this.createdAt,
    this.id,
    this.isConsultation,
    this.profession,
    this.timeWork,
    this.updatedAt,
  });
  
  factory EntityDoctorResponse.fromJson(Map<String, Object?> json) => _$EntityDoctorResponseFromJson(json);
  
  final EntityAccount? account;
  @JsonKey(name: 'count_articles')
  final int? countArticles;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  @JsonKey(name: 'is_consultation')
  final bool? isConsultation;
  final String? profession;
  @JsonKey(name: 'time_work')
  final EntityDoctorWorkTimeResponse? timeWork;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityDoctorResponseToJson(this);
}
