// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/pdf_pdf_dto.dart';

part 'pdf_client.g.dart';

@RestApi()
abstract class PdfClient {
  factory PdfClient(Dio dio, {String? baseUrl}) = _PdfClient;

  /// генерация pdf diapers.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/diapers/generate')
  Future<void> postPdfDiapersGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf consultation doctor.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/doc_cons/generate')
  Future<void> postPdfDocConsGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf drug.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/drug/generate')
  Future<void> postPdfDrugGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/feed/generate')
  Future<void> postPdfFeedGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/growth/generate')
  Future<void> postPdfGrowthGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf sleep cry.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/sleep_cry/generate')
  Future<void> postPdfSleepCryGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf temperature.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/temperature/generate')
  Future<void> postPdfTemperatureGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf vaccines.
  ///
  /// [dto] - pdfDTO.
  @POST('/pdf/vaccines/generate')
  Future<void> postPdfVaccinesGenerate({
    @Body() required PdfPdfDto dto,
  });
}
