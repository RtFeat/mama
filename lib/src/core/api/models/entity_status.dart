// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EntityStatus {
  @JsonValue('SUBSCRIBED')
  subscribed('SUBSCRIBED'),
  @JsonValue('PROMO_CODE')
  promoCode('PROMO_CODE'),
  @JsonValue('TRIAL')
  trial('TRIAL'),
  @JsonValue('NO_SUBSCRIBED')
  nOSubscribed('NO_SUBSCRIBED'),
  @JsonValue('DELETED')
  deleted('DELETED'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const EntityStatus(this.json);

  factory EntityStatus.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
