// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';

part 'entity_feedback.g.dart';

@JsonSerializable()
class EntityFeedback {
  const EntityFeedback({
    this.account,
    this.accountId,
    this.createdAt,
    this.id,
    this.status,
    this.text,
    this.type,
  });
  
  factory EntityFeedback.fromJson(Map<String, Object?> json) => _$EntityFeedbackFromJson(json);
  
  final EntityAccount? account;
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? id;
  final String? status;
  final String? text;
  final String? type;

  Map<String, Object?> toJson() => _$EntityFeedbackToJson(this);
}
