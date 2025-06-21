// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_account.dart';
import 'entity_doctor_base.dart';
import 'entity_online_school.dart';

part 'entity_account_me.g.dart';

@JsonSerializable()
class EntityAccountMe {
  const EntityAccountMe({
    this.account,
    this.doctor,
    this.onlineSchool,
  });
  
  factory EntityAccountMe.fromJson(Map<String, Object?> json) => _$EntityAccountMeFromJson(json);
  
  final EntityAccount? account;
  final EntityDoctorBase? doctor;
  @JsonKey(name: 'online_school')
  final EntityOnlineSchool? onlineSchool;

  Map<String, Object?> toJson() => _$EntityAccountMeToJson(this);
}
