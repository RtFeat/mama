// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'category_response_dto.g.dart';

@JsonSerializable()
class CategoryResponseDto {
  const CategoryResponseDto({
    this.id,
  });
  
  factory CategoryResponseDto.fromJson(Map<String, Object?> json) => _$CategoryResponseDtoFromJson(json);
  
  final String? id;

  Map<String, Object?> toJson() => _$CategoryResponseDtoToJson(this);
}
