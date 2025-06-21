// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';

part 'moderator_response_moderator.g.dart';

@JsonSerializable()
class ModeratorResponseModerator {
  const ModeratorResponseModerator({
    this.account,
  });
  
  factory ModeratorResponseModerator.fromJson(Map<String, Object?> json) => _$ModeratorResponseModeratorFromJson(json);
  
  final EntityAccount? account;

  Map<String, Object?> toJson() => _$ModeratorResponseModeratorToJson(this);
}
