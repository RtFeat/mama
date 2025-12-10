// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'consultation_update_dto.g.dart';

@JsonSerializable()
class ConsultationUpdateDto {
  const ConsultationUpdateDto({
    this.doctorId,
    this.status,
    this.timeBegin,
    this.type,
    this.userId,
  });
  
  factory ConsultationUpdateDto.fromJson(Map<String, Object?> json) => _$ConsultationUpdateDtoFromJson(json);
  
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  final String? status;
  @JsonKey(name: 'time_begin')
  final String? timeBegin;
  final String? type;
  @JsonKey(name: 'user_id')
  final String? userId;

  Map<String, Object?> toJson() => _$ConsultationUpdateDtoToJson(this);
}
