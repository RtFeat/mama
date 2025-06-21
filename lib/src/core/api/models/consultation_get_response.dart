// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_consultation_response.dart';

part 'consultation_get_response.g.dart';

@JsonSerializable()
class ConsultationGetResponse {
  const ConsultationGetResponse({
    this.consultation,
  });
  
  factory ConsultationGetResponse.fromJson(Map<String, Object?> json) => _$ConsultationGetResponseFromJson(json);
  
  final EntityConsultationResponse? consultation;

  Map<String, Object?> toJson() => _$ConsultationGetResponseToJson(this);
}
