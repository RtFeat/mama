import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

enum PdfType {
  vaccines,
  diapers,
  docCons,
  drug,
  feed,
  growth,
  sleepCry,
  temperature,
}

class PdfService {
  // Optional global messenger (not used currently)
  static GlobalKey<ScaffoldMessengerState>? rootMessengerKey;
  static Future<void> generateAndViewPdf({
    required BuildContext context,
    required PdfType pdfType,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
    RestClient? restClient,
    String? childId,
  }) async {
    if (!context.mounted) return;

    try {
      
      onStart?.call();

      final userStore = childId == null ? context.read<UserStore>() : null;
      final deps = context.read<Dependencies>();
      final RestClient rc = restClient ?? deps.restClient;
      
      // Get current child ID
      final String? cid = childId ?? userStore?.selectedChild?.id;
      if (cid == null) {
        _safeSnack('No child selected');
        return;
      }

      // Generate PDF based on type with timeout
      final bytes = await _generatePdfByType(rc, pdfType, cid, typeOfPdf)
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('PDF generation timed out after 30 seconds');
        },
      );

      // Success
      // Try to open/share the PDF on device
      try {
        if (bytes != null) {
          final dir = await getTemporaryDirectory();
          final path = '${dir.path}/$typeOfPdf-${DateTime.now().millisecondsSinceEpoch}.pdf';
          final file = File(path);
          await file.writeAsBytes(bytes);
          if (context.mounted) {
            context.pushNamed(AppViews.pdfView, extra: {
              'path': file.path,
              'title': title,
            });
          }
          onSuccess?.call();
        } else {
          onError?.call('Не удалось загрузить PDF-файл, попробуйте позже');
        }
      } catch (e) {
        onError?.call('Не удалось загрузить PDF-файл, попробуйте позже');
      }
    } on DioException catch (e) {
      // Graceful handling for backend errors (e.g., 5xx)
      final int? code = e.response?.statusCode;
      final String message = code != null && code >= 500
          ? 'Сервер недоступен. Попробуйте позже.'
          : 'Не удалось сформировать PDF. Пожалуйста, повторите попытку.';

      onError?.call(message);
    } catch (e) {
      onError?.call('Не удалось загрузить PDF-файл, попробуйте позже');
    }
  }

  // Removed direct context lookup in favor of early-captured messenger
  static void _showLoadingMessage(BuildContext context, String message) {}

  static void _safeSnack(String message, {Color? bg, int seconds = 2}) {}

  static Future<List<int>?> _generatePdfByType(
    RestClient restClient,
    PdfType pdfType,
    String childId,
    String typeOfPdf,
  ) async {
    final dto = PdfPdfDto(
      childId: childId,
      typeOfPdf: typeOfPdf,
    );


    try {
      List<int> bytes;
      switch (pdfType) {
        case PdfType.vaccines:
          bytes = await restClient.pdf.postPdfVaccinesGenerate(dto: dto);
          break;
        case PdfType.diapers:
          bytes = await restClient.pdf.postPdfDiapersGenerate(dto: dto);
          break;
        case PdfType.docCons:
          bytes = await restClient.pdf.postPdfDocConsGenerate(dto: dto);
          break;
        case PdfType.drug:
          bytes = await restClient.pdf.postPdfDrugGenerate(dto: dto);
          break;
        case PdfType.feed:
          bytes = await restClient.pdf.postPdfFeedGenerate(dto: dto);
          break;
        case PdfType.growth:
          bytes = await restClient.pdf.postPdfGrowthGenerate(dto: dto);
          break;
        case PdfType.sleepCry:
          bytes = await restClient.pdf.postPdfSleepCryGenerate(dto: dto);
          break;
        case PdfType.temperature:
          bytes = await restClient.pdf.postPdfTemperatureGenerate(dto: dto);
          break;
      }
      return bytes;
    } catch (e) {
      throw Exception('Не удалось загрузить PDF-файл, попробуйте позже');
    }
  }


  // Convenience methods for specific PDF types
  static Future<void> generateAndViewVaccinePdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.vaccines,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewDiapersPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.diapers,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewFeedPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.feed,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewGrowthPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
    RestClient? restClient,
    String? childId,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.growth,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
      restClient: restClient,
      childId: childId,
    );
  }

  static Future<void> generateAndViewSleepCryPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.sleepCry,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewTemperaturePdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.temperature,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewDrugPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.drug,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static Future<void> generateAndViewDocConsPdf({
    required BuildContext context,
    required String typeOfPdf,
    required String title,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    await generateAndViewPdf(
      context: context,
      pdfType: PdfType.docCons,
      typeOfPdf: typeOfPdf,
      title: title,
      onStart: onStart,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {}


  static void _showSuccessMessage(BuildContext context, String message) {}
}
