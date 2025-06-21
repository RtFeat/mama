// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_online_school_number.dart';

part 'online_school_resp_online_school_numbers.g.dart';

@JsonSerializable()
class OnlineSchoolRespOnlineSchoolNumbers {
  const OnlineSchoolRespOnlineSchoolNumbers({
    this.list,
  });
  
  factory OnlineSchoolRespOnlineSchoolNumbers.fromJson(Map<String, Object?> json) => _$OnlineSchoolRespOnlineSchoolNumbersFromJson(json);
  
  final List<EntityOnlineSchoolNumber>? list;

  Map<String, Object?> toJson() => _$OnlineSchoolRespOnlineSchoolNumbersToJson(this);
}
