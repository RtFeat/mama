// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_gender.dart';
import 'entity_role.dart';
import 'entity_state.dart';
import 'entity_status.dart';

part 'entity_account.g.dart';

@JsonSerializable()
class EntityAccount {
  const EntityAccount({
    this.avatar,
    this.createdAt,
    this.email,
    this.favoriteArticle,
    this.firstName,
    this.gender,
    this.id,
    this.info,
    this.isDeleted,
    this.lastActiveAt,
    this.lastName,
    this.online,
    this.phone,
    this.profession,
    this.role,
    this.secondName,
    this.state,
    this.status,
    this.updatedAt,
  });
  
  factory EntityAccount.fromJson(Map<String, Object?> json) => _$EntityAccountFromJson(json);
  
  final String? avatar;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  final String? email;
  @JsonKey(name: 'favorite_article')
  final String? favoriteArticle;
  @JsonKey(name: 'first_name')
  final String? firstName;
  final EntityGender? gender;
  final String? id;
  final String? info;
  @JsonKey(name: 'is_deleted')
  final bool? isDeleted;
  @JsonKey(name: 'last_active_at')
  final String? lastActiveAt;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final bool? online;
  final String? phone;
  final String? profession;
  final EntityRole? role;
  @JsonKey(name: 'second_name')
  final String? secondName;
  final EntityState? state;
  final EntityStatus? status;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, Object?> toJson() => _$EntityAccountToJson(this);
}
