// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_chest_notes_dto.g.dart';

@JsonSerializable()
class FeedChestNotesDto {
  const FeedChestNotesDto({
    required this.id,
    required this.notes,
  });
  
  factory FeedChestNotesDto.fromJson(Map<String, Object?> json) => _$FeedChestNotesDtoFromJson(json);
  
  final String id;
  final String notes;

  Map<String, Object?> toJson() => _$FeedChestNotesDtoToJson(this);
}
