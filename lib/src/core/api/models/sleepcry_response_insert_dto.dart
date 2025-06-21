// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sleepcry_response_insert_dto.g.dart';

@JsonSerializable()
class SleepcryResponseInsertDto {
  const SleepcryResponseInsertDto({
    this.id,
  });
  
  factory SleepcryResponseInsertDto.fromJson(Map<String, Object?> json) => _$SleepcryResponseInsertDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$SleepcryResponseInsertDtoToJson(this);
}
