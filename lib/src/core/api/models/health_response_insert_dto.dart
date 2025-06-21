// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'health_response_insert_dto.g.dart';

@JsonSerializable()
class HealthResponseInsertDto {
  const HealthResponseInsertDto({
    this.id,
  });
  
  factory HealthResponseInsertDto.fromJson(Map<String, Object?> json) => _$HealthResponseInsertDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$HealthResponseInsertDtoToJson(this);
}
