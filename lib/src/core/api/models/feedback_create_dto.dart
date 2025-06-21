// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feedback_create_dto.g.dart';

@JsonSerializable()
class FeedbackCreateDto {
  const FeedbackCreateDto({
    this.text,
  });
  
  factory FeedbackCreateDto.fromJson(Map<String, Object?> json) => _$FeedbackCreateDtoFromJson(json);
  
  final String? text;

  Map<String, Object?> toJson() => _$FeedbackCreateDtoToJson(this);
}
