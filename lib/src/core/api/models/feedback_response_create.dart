// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feedback_response_create.g.dart';

@JsonSerializable()
class FeedbackResponseCreate {
  const FeedbackResponseCreate({
    this.id,
  });
  
  factory FeedbackResponseCreate.fromJson(Map<String, Object?> json) => _$FeedbackResponseCreateFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$FeedbackResponseCreateToJson(this);
}
