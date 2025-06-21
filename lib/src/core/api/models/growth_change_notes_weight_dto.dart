// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'growth_change_notes_weight_dto.g.dart';

@JsonSerializable()
class GrowthChangeNotesWeightDto {
  const GrowthChangeNotesWeightDto({
    this.id,
    this.notes,
  });
  
  factory GrowthChangeNotesWeightDto.fromJson(Map<String, Object?> json) => _$GrowthChangeNotesWeightDtoFromJson(json);
  
  final String? id;
  final String? notes;

  Map<String, Object?> toJson() => _$GrowthChangeNotesWeightDtoToJson(this);
}
