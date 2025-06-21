// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'consultation_set_dto.g.dart';

@JsonSerializable()
class ConsultationSetDto {
  const ConsultationSetDto({
    this.comment,
    this.day,
    this.doctorId,
    this.slot,
    this.timeWeek,
    this.type,
    this.userId,
  });
  
  factory ConsultationSetDto.fromJson(Map<String, Object?> json) => _$ConsultationSetDtoFromJson(json);
  
  final String? comment;
  final String? day;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  final String? slot;
  @JsonKey(name: 'time_week')
  final String? timeWeek;
  final String? type;
  @JsonKey(name: 'user_id')
  final String? userId;

  Map<String, Object?> toJson() => _$ConsultationSetDtoToJson(this);
}
