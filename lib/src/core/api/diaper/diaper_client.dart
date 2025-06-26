// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/diapers_create_diaper_dto.dart';
import '../models/diapers_delete_diaper.dart';
import '../models/diapers_response_insert_dto.dart';
import '../models/diapers_response_list_diapers.dart';
import '../models/diapers_update_diaper_dto.dart';

part 'diaper_client.g.dart';

@RestApi()
abstract class DiaperClient {
  factory DiaperClient(Dio dio, {String? baseUrl}) = _DiaperClient;

  /// Добавить показатель подгузников.
  ///
  /// [dto] - Add diaper.
  @POST('/diaper/')
  Future<DiapersResponseInsertDto> postDiaper({
    @Body() required DiapersCreateDiaperDto dto,
  });

  /// Обновить показатель подгузников.
  ///
  /// [dto] - Update diaper.
  @PATCH('/diaper')
  Future<void> patchDiaper({
    @Body() required DiapersUpdateDiaperDto dto,
  });

  /// Удалить подгузники.
  ///
  /// [dto] - DTO delete drug.
  @DELETE('/diaper/')
  Future<void> deleteDiaper({
    @Body() required DiapersDeleteDiaper dto,
  });

  /// Вывести все подгузники ребенка.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @GET('/diaper/list')
  Future<DiapersResponseListDiapers> getDiaperList({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });
}
