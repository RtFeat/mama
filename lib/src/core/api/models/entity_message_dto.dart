// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_message_dto.g.dart';

@JsonSerializable()
class EntityMessageDto {
  const EntityMessageDto({
    this.filePath,
    this.filename,
    this.typeFile,
  });
  
  factory EntityMessageDto.fromJson(Map<String, Object?> json) => _$EntityMessageDtoFromJson(json);
  
  @JsonKey(name: 'file_path')
  final String? filePath;
  final String? filename;
  @JsonKey(name: 'type_file')
  final String? typeFile;

  Map<String, Object?> toJson() => _$EntityMessageDtoToJson(this);
}
