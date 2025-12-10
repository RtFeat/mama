// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_body_response.g.dart';

@JsonSerializable()
class EntityBodyResponse {
  const EntityBodyResponse({
    this.payload,
    this.type,
  });
  
  factory EntityBodyResponse.fromJson(Map<String, Object?> json) => _$EntityBodyResponseFromJson(json);
  
  final dynamic payload;
  final String? type;

  Map<String, Object?> toJson() => _$EntityBodyResponseToJson(this);
}
