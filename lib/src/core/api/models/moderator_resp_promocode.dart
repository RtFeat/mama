// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_promocode.dart';

part 'moderator_resp_promocode.g.dart';

@JsonSerializable()
class ModeratorRespPromocode {
  const ModeratorRespPromocode({
    this.list,
  });
  
  factory ModeratorRespPromocode.fromJson(Map<String, Object?> json) => _$ModeratorRespPromocodeFromJson(json);
  
  final List<EntityPromocode>? list;

  Map<String, Object?> toJson() => _$ModeratorRespPromocodeToJson(this);
}
