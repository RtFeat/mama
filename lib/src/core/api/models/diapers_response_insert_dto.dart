// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'diapers_response_insert_dto.g.dart';

@JsonSerializable()
class DiapersResponseInsertDto {
  const DiapersResponseInsertDto({
    this.id,
  });
  
  factory DiapersResponseInsertDto.fromJson(Map<String, Object?> json) => _$DiapersResponseInsertDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$DiapersResponseInsertDtoToJson(this);
}
