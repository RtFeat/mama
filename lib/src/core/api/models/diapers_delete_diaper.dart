// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'diapers_delete_diaper.g.dart';

@JsonSerializable()
class DiapersDeleteDiaper {
  const DiapersDeleteDiaper({
    required this.id,
  });
  
  factory DiapersDeleteDiaper.fromJson(Map<String, Object?> json) => _$DiapersDeleteDiaperFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$DiapersDeleteDiaperToJson(this);
}
