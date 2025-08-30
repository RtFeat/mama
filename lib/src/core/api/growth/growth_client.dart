// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:mama/src/data.dart';
import 'package:retrofit/retrofit.dart';

import '../models/growth_change_notes_circle_dto.dart';
import '../models/growth_change_notes_height_dto.dart';
import '../models/growth_change_notes_weight_dto.dart';
import '../models/growth_change_stats_circle_dto.dart';
import '../models/growth_change_stats_height_dto.dart';
import '../models/growth_change_stats_weight_dto.dart';
import '../models/growth_delete_circle_dto.dart';
import '../models/growth_delete_weight_dto.dart';
import '../models/growth_get_circle_response.dart';
import '../models/growth_get_height_response.dart';
import '../../../feature/trackers/models/evolution/table/growth_get_table_response.dart';
import '../models/growth_insert_circle_dto.dart';
import '../models/growth_insert_height_dto.dart';
import '../models/growth_insert_weight_dto.dart';
import '../models/growth_response_get_circle.dart';
import '../models/growth_response_get_height.dart';
import '../models/growth_response_get_weight.dart';
import '../models/growth_response_history_weight.dart';
import '../models/growth_response_insert.dart';

part 'growth_client.g.dart';

@RestApi()
abstract class GrowthClient {
  factory GrowthClient(Dio dio, {String? baseUrl}) = _GrowthClient;

  /// Вывести таблицу, динамику и текущий.
  ///
  /// [childId] - child id.
  @GET('/growth/circle')
  Future<GrowthGetCircleResponse> getGrowthCircle({
    @Query('child_id') required String childId,
  });

  /// Добавить показатель объема головы ребенка.
  ///
  /// [dto] - Add height.
  @POST('/growth/circle')
  Future<GrowthResponseInsert> postGrowthCircle({
    @Body() required GrowthInsertCircleDto dto,
  });

  /// Удалить заметку.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/circle/delete/notes')
  Future<void> deleteGrowthCircleDeleteNotes({
    @Body() required GrowthDeleteCircleDto dto,
  });

  /// Удалить статистику.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/circle/delete/stats')
  Future<void> deleteGrowthCircleDeleteStats({
    @Body() required GrowthDeleteCircleDto dto,
  });

  /// Вывести показатель ребенка.
  ///
  /// [childId] - child ID.
  ///
  /// [circleId] - circle ID.
  @GET('/growth/circle/get')
  Future<GrowthResponseGetCircle> getGrowthCircleGet({
    @Query('child_id') required String childId,
    @Query('circle_id') required String circleId,
  });

  /// Вывести историю объема головы.
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
  @GET('/growth/circle/history')
  Future<GrowthResponseHistoryCircle> getGrowthCircleHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Изменить заметку.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/circle/notes')
  Future<void> patchGrowthCircleNotes({
    @Body() required GrowthChangeNotesCircleDto dto,
  });

  /// Изменить объект статистики.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/circle/stats')
  Future<void> patchGrowthCircleStats({
    @Body() required GrowthChangeStatsCircleDto dto,
  });

  /// Вывести таблицу, динамику и текущий.
  ///
  /// [childId] - child id.
  @GET('/growth/height')
  Future<GrowthGetHeightResponse> getGrowthHeight({
    @Query('child_id') required String childId,
  });

  /// Добавить показатель роста ребенка.
  ///
  /// [dto] - Add height.
  @POST('/growth/height')
  Future<GrowthResponseInsert> postGrowthHeight({
    @Body() required GrowthInsertHeightDto dto,
  });

  /// Удалить заметку роста.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/height/delete/notes')
  Future<void> deleteGrowthHeightDeleteNotes({
    @Body() required GrowthDeleteHeightDto dto,
  });

  /// Удалить статистику роста.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/height/delete/stats')
  Future<void> deleteGrowthHeightDeleteStats({
    @Body() required GrowthDeleteHeightDto dto,
  });

  /// Вывести показатель ребенка роста.
  ///
  /// [childId] - child ID.
  ///
  /// [heightId] - height ID.
  @GET('/growth/height/get')
  Future<GrowthResponseGetHeight> getGrowthHeightGet({
    @Query('child_id') required String childId,
    @Query('height_id') required String heightId,
  });

  /// Вывести историю роста.
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
  @GET('/growth/height/history')
  Future<GrowthResponseHistoryHeight> getGrowthHeightHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Изменить заметку.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/height/notes')
  Future<void> patchGrowthHeightNotes({
    @Body() required GrowthChangeNotesHeightDto dto,
  });

  /// Изменить объект статистики.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/height/stats')
  Future<void> patchGrowthHeightStats({
    @Body() required GrowthChangeStatsHeightDto dto,
  });

  /// Вывести таблицу.
  ///
  /// [childId] - child ID.
  ///
  /// [sortType] - sort_type (new/old).
  @GET('/growth/table/{sort_type}')
  Future<GrowthGetTableResponse> getGrowthTableSortType({
    @Query('child_id') required String childId,
    @Path('sort_type') String? sortType,
  });

  /// Вывести таблицу, динамику и текущий.
  ///
  /// [childId] - child id.
  @GET('/growth/weight')
  Future<GrowthGetWeightResponse> getGrowthWeight({
    @Query('child_id') required String childId,
  });

  /// Добавить показатель веса ребенка.
  ///
  /// [dto] - Add weight.
  @POST('/growth/weight')
  Future<GrowthResponseInsert> postGrowthWeight({
    @Body() required GrowthInsertWeightDto dto,
  });

  /// Удалить заметку.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/weight/delete/notes')
  Future<void> deleteGrowthWeightDeleteNotes({
    @Body() required GrowthDeleteWeightDto dto,
  });

  /// Удалить статистику.
  ///
  /// [dto] - DTO.
  @DELETE('/growth/weight/delete/stats')
  Future<void> deleteGrowthWeightDeleteStats({
    @Body() required GrowthDeleteWeightDto dto,
  });

  /// Вывести показатель ребенка веса.
  ///
  /// [childId] - child ID.
  ///
  /// [weightId] - weight ID.
  @GET('/growth/weight/get')
  Future<GrowthResponseGetWeight> getGrowthWeightGet({
    @Query('child_id') required String childId,
    @Query('weight_id') required String weightId,
  });

  /// Вывести историю веса.
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
  @GET('/growth/weight/history')
  Future<GrowthResponseHistoryWeight> getGrowthWeightHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Изменить заметку.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/weight/notes')
  Future<void> patchGrowthWeightNotes({
    @Body() required GrowthChangeNotesWeightDto dto,
  });

  /// Изменить объект статистики.
  ///
  /// [dto] - DTO.
  @PATCH('/growth/weight/stats')
  Future<void> patchGrowthWeightStats({
    @Body() required GrowthChangeStatsWeightDto dto,
  });
}
