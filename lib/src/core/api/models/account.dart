// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_gender.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  const Account({
    required this.firstName,
    required this.phone,
    required this.secondName,
    this.fcmToken,
    this.gender,
    this.lastName,
  });
  
  factory Account.fromJson(Map<String, Object?> json) => _$AccountFromJson(json);
  
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  @JsonKey(name: 'first_name')
  final String firstName;
  final EntityGender? gender;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String phone;
  @JsonKey(name: 'second_name')
  final String secondName;

  Map<String, Object?> toJson() => _$AccountToJson(this);
}
