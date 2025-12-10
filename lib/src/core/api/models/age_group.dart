// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// Age group
@JsonEnum()
enum AgeGroup {
  @JsonValue('first')
  first('first'),
  @JsonValue('second')
  second('second'),
  @JsonValue('third')
  third('third'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const AgeGroup(this.json);

  factory AgeGroup.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
