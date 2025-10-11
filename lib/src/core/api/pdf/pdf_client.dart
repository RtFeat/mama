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
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/diapers/generate')
  Future<List<int>> postPdfDiapersGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf consultation doctor.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/doc_cons/generate')
  Future<List<int>> postPdfDocConsGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf drug.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/drug/generate')
  Future<List<int>> postPdfDrugGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/feed/generate')
  Future<List<int>> postPdfFeedGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/growth/generate')
  Future<List<int>> postPdfGrowthGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf sleep cry.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/sleep_cry/generate')
  Future<List<int>> postPdfSleepCryGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf temperature.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/temperature/generate')
  Future<List<int>> postPdfTemperatureGenerate({
    @Body() required PdfPdfDto dto,
  });

  /// генерация pdf vaccines.
  ///
  /// [dto] - pdfDTO.
  @DioResponseType(ResponseType.bytes)
  @POST('/pdf/vaccines/generate')
  Future<List<int>> postPdfVaccinesGenerate({
    @Body() required PdfPdfDto dto,
  });
}
