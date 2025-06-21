// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'entity_role.dart';

part 'entity_article_writer.g.dart';

@JsonSerializable()
class EntityArticleWriter {
  const EntityArticleWriter({
    this.accountId,
    this.doctorProfession,
    this.firstName,
    this.lastName,
    this.photoId,
    this.role,
  });
  
  factory EntityArticleWriter.fromJson(Map<String, Object?> json) => _$EntityArticleWriterFromJson(json);
  
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'doctor_profession')
  final String? doctorProfession;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'photo_id')
  final String? photoId;
  final EntityRole? role;

  Map<String, Object?> toJson() => _$EntityArticleWriterToJson(this);
}
