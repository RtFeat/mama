// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_change_notes_height_dto.g.dart';

@JsonSerializable()
class GrowthChangeNotesHeightDto {
  const GrowthChangeNotesHeightDto({
    this.id,
    this.notes,
  });
  
  factory GrowthChangeNotesHeightDto.fromJson(Map<String, Object?> json) => _$GrowthChangeNotesHeightDtoFromJson(json);
  
  final String? id;
  final String? notes;

  Map<String, Object?> toJson() => _$GrowthChangeNotesHeightDtoToJson(this);
}
