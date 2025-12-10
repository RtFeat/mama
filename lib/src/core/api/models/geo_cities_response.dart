// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_city.dart';

part 'geo_cities_response.g.dart';

@JsonSerializable()
class GeoCitiesResponse {
  const GeoCitiesResponse({
    this.cities,
  });
  
  factory GeoCitiesResponse.fromJson(Map<String, Object?> json) => _$GeoCitiesResponseFromJson(json);
  
  final List<EntityCity>? cities;

  Map<String, Object?> toJson() => _$GeoCitiesResponseToJson(this);
}
