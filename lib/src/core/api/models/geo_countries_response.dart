// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_country.dart';

part 'geo_countries_response.g.dart';

@JsonSerializable()
class GeoCountriesResponse {
  const GeoCountriesResponse({
    this.countries,
  });
  
  factory GeoCountriesResponse.fromJson(Map<String, Object?> json) => _$GeoCountriesResponseFromJson(json);
  
  final List<EntityCountry>? countries;

  Map<String, Object?> toJson() => _$GeoCountriesResponseToJson(this);
}
