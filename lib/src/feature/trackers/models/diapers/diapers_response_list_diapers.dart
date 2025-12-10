// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_diapers_main.dart';

part 'diapers_response_list_diapers.g.dart';

@JsonSerializable()
class DiapersResponseListDiapers {
  const DiapersResponseListDiapers({
    this.list,
  });

  factory DiapersResponseListDiapers.fromJson(Map<String, Object?> json) =>
      _$DiapersResponseListDiapersFromJson(json);

  final List<EntityDiapersMain>? list;

  Map<String, Object?> toJson() => _$DiapersResponseListDiapersToJson(this);
}
