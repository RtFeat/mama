// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_online_school_number.g.dart';

@JsonSerializable()
class EntityOnlineSchoolNumber {
  const EntityOnlineSchoolNumber({
    this.id,
    this.onlineSchoolId,
    this.phone,
  });
  
  factory EntityOnlineSchoolNumber.fromJson(Map<String, Object?> json) => _$EntityOnlineSchoolNumberFromJson(json);
  
  final String? id;
  @JsonKey(name: 'online_school_id')
  final String? onlineSchoolId;
  final String? phone;

  Map<String, Object?> toJson() => _$EntityOnlineSchoolNumberToJson(this);
}
