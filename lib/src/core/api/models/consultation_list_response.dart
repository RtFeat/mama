// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_consultation_response.dart';

part 'consultation_list_response.g.dart';

@JsonSerializable()
class ConsultationListResponse {
  const ConsultationListResponse({
    this.consultations,
  });
  
  factory ConsultationListResponse.fromJson(Map<String, Object?> json) => _$ConsultationListResponseFromJson(json);
  
  final List<EntityConsultationResponse>? consultations;

  Map<String, Object?> toJson() => _$ConsultationListResponseToJson(this);
}
