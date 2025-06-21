// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EntityRole {
  @JsonValue('ADMIN')
  admin('ADMIN'),
  @JsonValue('MODERATOR')
  moderator('MODERATOR'),
  @JsonValue('DOCTOR')
  doctor('DOCTOR'),
  @JsonValue('USER')
  user('USER'),
  @JsonValue('ONLINE_SCHOOL')
  onlineSchool('ONLINE_SCHOOL'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const EntityRole(this.json);

  factory EntityRole.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
