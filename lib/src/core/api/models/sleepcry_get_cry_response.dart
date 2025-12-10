// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_cry.dart';

part 'sleepcry_get_cry_response.g.dart';

@JsonSerializable()
class SleepcryGetCryResponse {
  const SleepcryGetCryResponse({
    this.list,
  });
  
  factory SleepcryGetCryResponse.fromJson(Map<String, Object?> json) => _$SleepcryGetCryResponseFromJson(json);
  
  final List<EntityCry>? list;

  Map<String, Object?> toJson() => _$SleepcryGetCryResponseToJson(this);
}
