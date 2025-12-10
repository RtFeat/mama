// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_stat_account_buy.dart';

part 'moderator_stat_resp.g.dart';

@JsonSerializable()
class ModeratorStatResp {
  const ModeratorStatResp({
    this.list,
  });
  
  factory ModeratorStatResp.fromJson(Map<String, Object?> json) => _$ModeratorStatRespFromJson(json);
  
  final List<EntityStatAccountBuy>? list;

  Map<String, Object?> toJson() => _$ModeratorStatRespToJson(this);
}
