// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_main_drug.dart';

part 'health_response_list_drug.g.dart';

@JsonSerializable()
class HealthResponseListDrug {
  const HealthResponseListDrug({
    this.list,
  });

  factory HealthResponseListDrug.fromJson(Map<String, Object?> json) =>
      _$HealthResponseListDrugFromJson(json);

  final List<EntityMainDrug>? list;

  Map<String, Object?> toJson() => _$HealthResponseListDrugToJson(this);
}
