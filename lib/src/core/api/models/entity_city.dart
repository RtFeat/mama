// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_city.g.dart';

@JsonSerializable()
class EntityCity {
  const EntityCity({
    this.countryId,
    this.countryName,
    this.id,
    this.name,
  });
  
  factory EntityCity.fromJson(Map<String, Object?> json) => _$EntityCityFromJson(json);
  
  @JsonKey(name: 'country_id')
  final int? countryId;
  @JsonKey(name: 'country_name')
  final String? countryName;
  final int? id;
  final String? name;

  Map<String, Object?> toJson() => _$EntityCityToJson(this);
}
