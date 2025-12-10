// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'pdf_pdf_dto.g.dart';

@JsonSerializable()
class PdfPdfDto {
  const PdfPdfDto({
    this.childId,
    this.typeOfPdf,
  });
  
  factory PdfPdfDto.fromJson(Map<String, Object?> json) => _$PdfPdfDtoFromJson(json);
  
  @JsonKey(name: 'child_id')
  final String? childId;
  @JsonKey(name: 'type_of_pdf')
  final String? typeOfPdf;

  Map<String, Object?> toJson() => _$PdfPdfDtoToJson(this);
}
