// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_main_drug.g.dart';

@JsonSerializable()
class EntityMainDrug {
  const EntityMainDrug({
    this.dose,
    this.id,
    this.imageId,
    this.isEnd,
    this.name,
    this.notes,
    this.reminder,
    this.reminderAfter,
  });
  
  factory EntityMainDrug.fromJson(Map<String, Object?> json) => _$EntityMainDrugFromJson(json);
  
  final String? dose;
  final String? id;
  @JsonKey(name: 'image_id')
  final String? imageId;
  final bool? isEnd;
  final String? name;
  final String? notes;
  final String? reminder;
  @JsonKey(name: 'reminder_after')
  final String? reminderAfter;

  Map<String, Object?> toJson() => _$EntityMainDrugToJson(this);
}
