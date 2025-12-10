// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_delete_vaccination.g.dart';

@JsonSerializable()
class HealthDeleteVaccination {
  const HealthDeleteVaccination({
    required this.id,
  });
  
  factory HealthDeleteVaccination.fromJson(Map<String, Object?> json) => _$HealthDeleteVaccinationFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$HealthDeleteVaccinationToJson(this);
}
