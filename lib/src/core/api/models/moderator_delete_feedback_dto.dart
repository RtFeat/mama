// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_delete_feedback_dto.g.dart';

@JsonSerializable()
class ModeratorDeleteFeedbackDto {
  const ModeratorDeleteFeedbackDto({
    this.id,
  });
  
  factory ModeratorDeleteFeedbackDto.fromJson(Map<String, Object?> json) => _$ModeratorDeleteFeedbackDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$ModeratorDeleteFeedbackDtoToJson(this);
}
