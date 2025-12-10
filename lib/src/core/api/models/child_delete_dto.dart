// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'child_delete_dto.g.dart';

@JsonSerializable()
class ChildDeleteDto {
  const ChildDeleteDto({
    required this.childId,
  });
  
  factory ChildDeleteDto.fromJson(Map<String, Object?> json) => _$ChildDeleteDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String childId;

  Map<String, Object?> toJson() => _$ChildDeleteDtoToJson(this);
}
