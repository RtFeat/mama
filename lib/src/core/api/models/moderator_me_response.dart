// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';

part 'moderator_me_response.g.dart';

@JsonSerializable()
class ModeratorMeResponse {
  const ModeratorMeResponse({
    this.account,
  });
  
  factory ModeratorMeResponse.fromJson(Map<String, Object?> json) => _$ModeratorMeResponseFromJson(json);
  
  final EntityAccount? account;

  Map<String, Object?> toJson() => _$ModeratorMeResponseToJson(this);
}
