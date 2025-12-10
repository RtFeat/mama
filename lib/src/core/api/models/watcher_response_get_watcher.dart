// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_watcher.dart';

part 'watcher_response_get_watcher.g.dart';

@JsonSerializable()
class WatcherResponseGetWatcher {
  const WatcherResponseGetWatcher({
    this.list,
  });
  
  factory WatcherResponseGetWatcher.fromJson(Map<String, Object?> json) => _$WatcherResponseGetWatcherFromJson(json);
  
  final EntityWatcher? list;

  Map<String, Object?> toJson() => _$WatcherResponseGetWatcherToJson(this);
}
