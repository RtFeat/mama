// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'music_update_dto.g.dart';

@JsonSerializable()
class MusicUpdateDto {
  const MusicUpdateDto({
    this.musicId,
    this.status,
  });
  
  factory MusicUpdateDto.fromJson(Map<String, Object?> json) => _$MusicUpdateDtoFromJson(json);
  
  @JsonKey(name: 'music_id')
  final String? musicId;
  final String? status;

  Map<String, Object?> toJson() => _$MusicUpdateDtoToJson(this);
}
