// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// Category
@JsonEnum()
enum Category {
  @JsonValue('music')
  music('music'),
  @JsonValue('story')
  story('story'),
  @JsonValue('whiteNoise')
  whiteNoise('whiteNoise'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Category(this.json);

  factory Category.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
