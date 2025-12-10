// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account_me.dart';

part 'account_response_account_me.g.dart';

@JsonSerializable()
class AccountResponseAccountMe {
  const AccountResponseAccountMe({
    this.account,
  });
  
  factory AccountResponseAccountMe.fromJson(Map<String, Object?> json) => _$AccountResponseAccountMeFromJson(json);
  
  final EntityAccountMe? account;

  Map<String, Object?> toJson() => _$AccountResponseAccountMeToJson(this);
}
