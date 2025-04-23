import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:mama/src/data.dart';

part 'account_me.g.dart';

@JsonSerializable()
class AccountMe extends BaseModel {
  @JsonKey(name: 'account')
  final AccountModel? account;
  @JsonKey(name: 'doctor')
  final Doctor? doctor;
  @JsonKey(name: 'online_school')
  final OnlineSchool? onlineSchool;

  AccountMe({
    this.account,
    this.doctor,
    this.onlineSchool,
  });

  AccountMe copyWith({
    AccountModel? account,
    Doctor? doctor,
    OnlineSchool? onlineSchool,
  }) =>
      AccountMe(
        account: account ?? this.account,
        doctor: doctor ?? this.doctor,
        onlineSchool: onlineSchool ?? this.onlineSchool,
      );

  factory AccountMe.fromJson(Map<String, dynamic> json) =>
      _$AccountMeFromJson(json);

  Map<String, dynamic> toJson() => _$AccountMeToJson(this);
}

@JsonSerializable()
class Doctor {
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'is_consultation')
  final bool? isConsultation;
  @JsonKey(name: 'profession')
  final String? profession;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Doctor({
    this.accountId,
    this.createdAt,
    this.id,
    this.isConsultation,
    this.profession,
    this.updatedAt,
  });

  Doctor copyWith({
    String? accountId,
    String? createdAt,
    String? id,
    bool? isConsultation,
    String? profession,
    String? updatedAt,
  }) =>
      Doctor(
        accountId: accountId ?? this.accountId,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        isConsultation: isConsultation ?? this.isConsultation,
        profession: profession ?? this.profession,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}

@JsonSerializable()
class OnlineSchool {
  @JsonKey(name: 'account')
  final String? account;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  OnlineSchool({
    this.account,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });

  OnlineSchool copyWith({
    String? account,
    String? createdAt,
    String? id,
    String? name,
    String? updatedAt,
  }) =>
      OnlineSchool(
        account: account ?? this.account,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        name: name ?? this.name,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory OnlineSchool.fromJson(Map<String, dynamic> json) =>
      _$OnlineSchoolFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineSchoolToJson(this);
}
