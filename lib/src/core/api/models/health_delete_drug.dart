// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_delete_drug.g.dart';

@JsonSerializable()
class HealthDeleteDrug {
  const HealthDeleteDrug({
    required this.id,
  });
  
  factory HealthDeleteDrug.fromJson(Map<String, Object?> json) => _$HealthDeleteDrugFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$HealthDeleteDrugToJson(this);
}
