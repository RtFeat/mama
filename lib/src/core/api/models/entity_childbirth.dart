// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EntityChildbirth {
  @JsonValue('NATURAL')
  natural('NATURAL'),
  @JsonValue('CAESAREAN')
  caesarean('CAESAREAN'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const EntityChildbirth(this.json);

  factory EntityChildbirth.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
