// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_completed_drug.g.dart';

@JsonSerializable()
class HealthCompletedDrug {
  const HealthCompletedDrug({
    this.drugId,
  });
  
  factory HealthCompletedDrug.fromJson(Map<String, Object?> json) => _$HealthCompletedDrugFromJson(json);
  
  @JsonKey(name: 'drug_id')
  final String? drugId;

  Map<String, Object?> toJson() => _$HealthCompletedDrugToJson(this);
}
