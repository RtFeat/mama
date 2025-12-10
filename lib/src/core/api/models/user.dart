// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    this.city,
    this.roles,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  final String? city;
  final List<String>? roles;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
