// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// Type consultation
@JsonEnum()
enum Type {
  @JsonValue('CHAT')
  chat('CHAT'),
  @JsonValue('VIDEO')
  video('VIDEO'),
  @JsonValue('EXPRESS')
  express('EXPRESS'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Type(this.json);

  factory Type.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
