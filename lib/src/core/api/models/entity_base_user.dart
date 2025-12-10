// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_base_user.g.dart';

@JsonSerializable()
class EntityBaseUser {
  const EntityBaseUser({
    this.accountId,
    this.city,
    this.createdId,
    this.endPrime,
    this.id,
    this.roles,
    this.startPrime,
    this.typePrime,
    this.updatedId,
  });
  
  factory EntityBaseUser.fromJson(Map<String, Object?> json) => _$EntityBaseUserFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  final String? city;
  @JsonKey(name: 'created_id')
  final String? createdId;
  @JsonKey(name: 'end_prime')
  final String? endPrime;
  final String? id;
  final List<String>? roles;
  @JsonKey(name: 'start_prime')
  final String? startPrime;
  @JsonKey(name: 'type_prime')
  final String? typePrime;
  @JsonKey(name: 'updated_id')
  final String? updatedId;

  Map<String, Object?> toJson() => _$EntityBaseUserToJson(this);
}
