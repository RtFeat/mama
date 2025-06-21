// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EntityState {
  @JsonValue('ACTIVE')
  active('ACTIVE'),
  @JsonValue('INACTIVE')
  inactive('INACTIVE'),
  @JsonValue('DELETED')
  deleted('DELETED'),
  @JsonValue('BLOCKED')
  blocked('BLOCKED'),
  @JsonValue('UNREGISTERED')
  unregistered('UNREGISTERED'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const EntityState(this.json);

  factory EntityState.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
