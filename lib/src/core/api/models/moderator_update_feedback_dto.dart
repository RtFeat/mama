// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_update_feedback_dto.g.dart';

@JsonSerializable()
class ModeratorUpdateFeedbackDto {
  const ModeratorUpdateFeedbackDto({
    this.id,
    this.status,
  });
  
  factory ModeratorUpdateFeedbackDto.fromJson(Map<String, Object?> json) => _$ModeratorUpdateFeedbackDtoFromJson(json);
  
  final String? id;
  final String? status;

  Map<String, Object?> toJson() => _$ModeratorUpdateFeedbackDtoToJson(this);
}
