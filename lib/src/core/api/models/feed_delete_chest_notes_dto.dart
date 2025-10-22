// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_delete_chest_notes_dto.g.dart';

@JsonSerializable()
class FeedDeleteChestNotesDto {
  const FeedDeleteChestNotesDto({
    required this.id,
  });
  
  factory FeedDeleteChestNotesDto.fromJson(Map<String, Object?> json) => _$FeedDeleteChestNotesDtoFromJson(json);
  
  final String id;

  Map<String, Object?> toJson() => _$FeedDeleteChestNotesDtoToJson(this);
}
