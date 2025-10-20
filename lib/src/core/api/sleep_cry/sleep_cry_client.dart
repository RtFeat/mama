// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/sleepcry_get_cry_response.dart';
import '../models/sleepcry_get_sleep_response.dart';
import '../models/sleepcry_insert_cry_dto.dart';
import '../models/sleepcry_insert_sleep_dto.dart';
import '../models/sleepcry_response_history_cry.dart';
import '../models/sleepcry_response_history_sleep.dart';
import '../models/sleepcry_response_history_table.dart';
import '../models/sleepcry_response_history_table_period.dart';
import '../models/sleepcry_response_insert_dto.dart';
import '../models/sleepcry_delete_sleep_dto.dart';
import '../models/sleepcry_update_sleep_dto.dart';
import '../models/sleepcry_update_cry_dto.dart';

part 'sleep_cry_client.g.dart';

@RestApi()
abstract class SleepCryClient {
  factory SleepCryClient(Dio dio, {String? baseUrl}) = _SleepCryClient;

  /// Добавить показатель крика.
  ///
  /// [dto] - Add cry.
  @POST('/sleep_cry/cry')
  Future<SleepcryResponseInsertDto> postSleepCryCry({
    @Body() required SleepcryInsertCryDto dto,
  });

  /// Вывести данные в указаннвый диапозон для крика.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @GET('/sleep_cry/cry/get')
  Future<SleepcryGetCryResponse> getSleepCryCryGet({
    @Query('child_id') required String childId,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });

  /// Вывести историю крика.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - child id.
  @GET('/sleep_cry/cry/history')
  Future<SleepcryResponseHistoryCry> getSleepCryCryHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Вывести таблицу сна и плача.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @POST('/sleep_cry/period_table')
  Future<SleepcryResponseHistoryTablePeriod> postSleepCryPeriodTable({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });

  /// Добавить показатель сна.
  ///
  /// [dto] - Add sleep.
  @POST('/sleep_cry/sleep')
  Future<SleepcryResponseInsertDto> postSleepCrySleep({
    @Body() required SleepcryInsertSleepDto dto,
  });

  /// Вывести данные в указаннвый диапозон для сна.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @GET('/sleep_cry/sleep/get')
  Future<SleepcryGetSleepResponse> getSleepCrySleepGet({
    @Query('child_id') required String childId,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });

  /// Вывести историю сна.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - child id.
  @GET('/sleep_cry/sleep/history')
  Future<SleepcryResponseHistorySleep> getSleepCrySleepHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Удалить заметку сна.
  ///
  /// [dto] - DTO.
  @DELETE('/sleep_cry/sleep/delete/notes')
  Future<void> deleteSleepCrySleepDeleteNotes({
    @Body() required SleepcryDeleteSleepDto dto,
  });

  /// Удалить статистику крика.
  ///
  /// [dto] - DTO.
  @DELETE('/sleep_cry/cry/delete/stats')
  Future<void> deleteSleepCryCryDeleteStats({
    @Body() required SleepcryDeleteSleepDto dto,
  });

  /// Обновить статистику крика.
  ///
  /// [dto] - Update cry stats.
  @PATCH('/sleep_cry/cry/stats')
  Future<void> patchSleepCryCryStats({
    @Body() required SleepcryUpdateCryDto dto,
  });

  /// Удалить заметку крика.
  ///
  /// [dto] - DTO.
  @DELETE('/sleep_cry/cry/delete/notes')
  Future<void> deleteSleepCryCryDeleteNotes({
    @Body() required SleepcryDeleteSleepDto dto,
  });

  /// Вывести таблицу сна и плача.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [sortType] - sort_type (new/old).
  ///
  /// [childId] - child id.
  @GET('/sleep_cry/table/{sort_type}')
  Future<SleepcryResponseHistoryTable> getSleepCryTableSortType({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Path('sort_type') String? sortType,
  });

  /// Удалить статистику сна.
  ///
  /// [dto] - Delete sleep stats.
  @DELETE('/sleep_cry/sleep/delete/stats')
  Future<void> deleteSleepCrySleepDeleteStats({
    @Body() required SleepcryDeleteSleepDto dto,
  });

  /// Обновить статистику сна.
  ///
  /// [dto] - Update sleep stats.
  @PATCH('/sleep_cry/sleep/stats')
  Future<void> patchSleepCrySleepStats({
    @Body() required SleepcryUpdateSleepDto dto,
  });

}
