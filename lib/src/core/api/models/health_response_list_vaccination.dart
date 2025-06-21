// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_vaccination_main.dart';

part 'health_response_list_vaccination.g.dart';

@JsonSerializable()
class HealthResponseListVaccination {
  const HealthResponseListVaccination({
    this.list,
  });
  
  factory HealthResponseListVaccination.fromJson(Map<String, Object?> json) => _$HealthResponseListVaccinationFromJson(json);
  
  final List<EntityVaccinationMain>? list;

  Map<String, Object?> toJson() => _$HealthResponseListVaccinationToJson(this);
}
