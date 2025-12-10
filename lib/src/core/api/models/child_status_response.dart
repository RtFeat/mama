// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_status_of_child.dart';

part 'child_status_response.g.dart';

@JsonSerializable()
class ChildStatusResponse {
  const ChildStatusResponse({
    required this.status,
  });
  
  factory ChildStatusResponse.fromJson(Map<String, Object?> json) => _$ChildStatusResponseFromJson(json);
  
  final EntityStatusOfChild status;

  Map<String, Object?> toJson() => _$ChildStatusResponseToJson(this);
}
