// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_response_doc_vaccination.g.dart';

@JsonSerializable()
class HealthResponseDocVaccination {
  const HealthResponseDocVaccination({
    this.id,
    this.photo,
  });
  
  factory HealthResponseDocVaccination.fromJson(Map<String, Object?> json) => _$HealthResponseDocVaccinationFromJson(json);
  
  final String? id;
  final String? photo;

  Map<String, Object?> toJson() => _$HealthResponseDocVaccinationToJson(this);
}
