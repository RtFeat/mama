// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'entity_watcher.g.dart';

@JsonSerializable()
class EntityWatcher {
  const EntityWatcher({
    this.accountId,
    this.bottle,
    this.chest,
    this.circle,
    this.cry,
    this.doctor,
    this.drug,
    this.height,
    this.id,
    this.lure,
    this.pumping,
    this.sleep,
    this.temperature,
    this.vaccinations,
    this.weight,
  });
  
  factory EntityWatcher.fromJson(Map<String, Object?> json) => _$EntityWatcherFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  final bool? bottle;
  final bool? chest;
  final bool? circle;
  final bool? cry;
  final bool? doctor;
  final bool? drug;
  final bool? height;
  final String? id;
  final bool? lure;
  final bool? pumping;
  final bool? sleep;
  final bool? temperature;
  final bool? vaccinations;
  final bool? weight;

  Map<String, Object?> toJson() => _$EntityWatcherToJson(this);
}
