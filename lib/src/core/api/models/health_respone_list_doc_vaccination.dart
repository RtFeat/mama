// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'health_response_doc_vaccination.dart';

part 'health_respone_list_doc_vaccination.g.dart';

@JsonSerializable()
class HealthResponeListDocVaccination {
  const HealthResponeListDocVaccination({
    this.list,
  });
  
  factory HealthResponeListDocVaccination.fromJson(Map<String, Object?> json) => _$HealthResponeListDocVaccinationFromJson(json);
  
  final List<HealthResponseDocVaccination>? list;

  Map<String, Object?> toJson() => _$HealthResponeListDocVaccinationToJson(this);
}
