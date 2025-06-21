// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'moderator_stat_req.g.dart';

@JsonSerializable()
class ModeratorStatReq {
  const ModeratorStatReq({
    this.fromTime,
    this.toTime,
  });
  
  factory ModeratorStatReq.fromJson(Map<String, Object?> json) => _$ModeratorStatReqFromJson(json);
  
  @JsonKey(name: 'from_time')
  final String? fromTime;
  @JsonKey(name: 'to_time')
  final String? toTime;

  Map<String, Object?> toJson() => _$ModeratorStatReqToJson(this);
}
