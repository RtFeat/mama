// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'article_update_status.g.dart';

@JsonSerializable()
class ArticleUpdateStatus {
  const ArticleUpdateStatus({
    this.id,
    this.status,
  });
  
  factory ArticleUpdateStatus.fromJson(Map<String, Object?> json) => _$ArticleUpdateStatusFromJson(json);
  
  final String? id;
  final String? status;

  Map<String, Object?> toJson() => _$ArticleUpdateStatusToJson(this);
}
