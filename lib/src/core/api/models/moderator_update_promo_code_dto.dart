// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_update_promo_code_dto.g.dart';

@JsonSerializable()
class ModeratorUpdatePromoCodeDto {
  const ModeratorUpdatePromoCodeDto({
    this.id,
    this.status,
    this.type,
  });
  
  factory ModeratorUpdatePromoCodeDto.fromJson(Map<String, Object?> json) => _$ModeratorUpdatePromoCodeDtoFromJson(json);
  
  final String? id;
  final String? status;
  final String? type;

  Map<String, Object?> toJson() => _$ModeratorUpdatePromoCodeDtoToJson(this);
}
