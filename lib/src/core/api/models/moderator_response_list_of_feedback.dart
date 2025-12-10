// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_feedback.dart';

part 'moderator_response_list_of_feedback.g.dart';

@JsonSerializable()
class ModeratorResponseListOfFeedback {
  const ModeratorResponseListOfFeedback({
    this.feedback,
  });
  
  factory ModeratorResponseListOfFeedback.fromJson(Map<String, Object?> json) => _$ModeratorResponseListOfFeedbackFromJson(json);
  
  final List<EntityFeedback>? feedback;

  Map<String, Object?> toJson() => _$ModeratorResponseListOfFeedbackToJson(this);
}
