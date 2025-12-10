// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_country.g.dart';

@JsonSerializable()
class EntityCountry {
  const EntityCountry({
    this.id,
    this.name,
  });
  
  factory EntityCountry.fromJson(Map<String, Object?> json) => _$EntityCountryFromJson(json);
  
  final int? id;
  final String? name;

  Map<String, Object?> toJson() => _$EntityCountryToJson(this);
}
