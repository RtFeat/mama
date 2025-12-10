// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_stat_account_buy.g.dart';

@JsonSerializable()
class EntityStatAccountBuy {
  const EntityStatAccountBuy({
    this.countSub,
    this.howMuchSub,
    this.typeSub,
  });
  
  factory EntityStatAccountBuy.fromJson(Map<String, Object?> json) => _$EntityStatAccountBuyFromJson(json);
  
  @JsonKey(name: 'count_sub')
  final int? countSub;
  @JsonKey(name: 'how_much_sub')
  final String? howMuchSub;
  @JsonKey(name: 'type_sub')
  final String? typeSub;

  Map<String, Object?> toJson() => _$EntityStatAccountBuyToJson(this);
}
