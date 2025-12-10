// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_cry.dart';
import 'entity_sleep.dart';

part 'entity_cry_and_sleep.g.dart';

@JsonSerializable()
class EntityCryAndSleep {
  const EntityCryAndSleep({
    this.cry,
    this.sleep,
  });
  
  factory EntityCryAndSleep.fromJson(Map<String, Object?> json) => _$EntityCryAndSleepFromJson(json);
  
  final List<EntityCry>? cry;
  final List<EntitySleep>? sleep;

  Map<String, Object?> toJson() => _$EntityCryAndSleepToJson(this);
}
