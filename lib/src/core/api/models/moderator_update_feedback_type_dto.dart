// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_update_feedback_type_dto.g.dart';

@JsonSerializable()
class ModeratorUpdateFeedbackTypeDto {
  const ModeratorUpdateFeedbackTypeDto({
    this.id,
    this.type,
  });
  
  factory ModeratorUpdateFeedbackTypeDto.fromJson(Map<String, Object?> json) => _$ModeratorUpdateFeedbackTypeDtoFromJson(json);
  
  final String? id;
  final String? type;

  Map<String, Object?> toJson() => _$ModeratorUpdateFeedbackTypeDtoToJson(this);
}
