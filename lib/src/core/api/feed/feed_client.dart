// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/feed_get_feeding_response.dart';
import '../models/feed_get_food_response.dart';
import '../models/feed_insert_chest_dto.dart';
import '../models/feed_insert_food_dto.dart';
import '../models/feed_insert_lure_dto.dart';
import '../models/feed_insert_pumping_dto.dart';
import '../models/feed_response_history_chest.dart';
import '../models/feed_response_history_food.dart';
import '../models/feed_response_history_lure.dart';
import '../models/feed_response_history_pumping.dart';
import '../models/feed_response_history_table.dart';
import '../models/feed_response_insert_dto.dart';
import '../models/feed_delete_pumping_dto.dart';
import '../models/feed_delete_food_dto.dart';
import '../models/feed_delete_lure_dto.dart';

part 'feed_client.g.dart';

@RestApi()
abstract class FeedClient {
  factory FeedClient(Dio dio, {String? baseUrl}) = _FeedClient;

  /// Добавить показатель кормления.
  ///
  /// left, right - количество минут.
  ///
  /// [dto] - Add chest.
  @POST('/feed/chest')
  Future<void> postFeedChest({
    @Body() required FeedInsertChestDto dto,
  });

  /// Вывести историю кормления грудью.
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
  @GET('/feed/chest/history')
  Future<FeedResponseHistoryChest> getFeedChestHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Добавить показатель кормления.
  ///
  /// [dto] - Add pumping.
  @POST('/feed/food')
  Future<FeedResponseInsertDto> postFeedFood({
    @Body() required FeedInsertFoodDto dto,
  });

  /// Вывести данные в указаннвый диапозон для кормления.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @GET('/feed/food/get')
  Future<FeedGetFoodResponse> getFeedFoodGet({
    @Query('child_id') required String childId,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });

  /// Вывести историю кормления.
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
  @GET('/feed/food/history')
  Future<FeedResponseHistoryFood> getFeedFoodHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Добавить показатель прикорма.
  ///
  /// [dto] - Add lure.
  @POST('/feed/lure')
  Future<void> postFeedLure({
    @Body() required FeedInsertLureDto dto,
  });

  /// Вывести историю прикорма.
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
  @GET('/feed/lure/history')
  Future<FeedResponseHistoryLure> getFeedLureHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Добавить показатель сцеживания.
  ///
  /// [dto] - Add pumping.
  @POST('/feed/pumping')
  Future<FeedResponseInsertDto> postFeedPumping({
    @Body() required FeedInsertPumpingDto dto,
  });

  /// Вывести данные в указаннвый диапозон для сцеживания.
  ///
  /// [childId] - Child ID.
  ///
  /// [fromTime] - From Time.
  ///
  /// [toTime] - To Time.
  @GET('/feed/pumping/get')
  Future<FeedGetFeedingResponse> getFeedPumpingGet({
    @Query('child_id') required String childId,
    @Query('from_time') String? fromTime,
    @Query('to_time') String? toTime,
  });

  /// Вывести историю сцеживания.
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
  @GET('/feed/pumping/history')
  Future<FeedResponseHistoryPumping> getFeedPumpingHistory({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Удалить статистику сцеживания.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/pumping/delete/stats')
  Future<void> deleteFeedPumpingDeleteStats({
    @Body() required FeedDeletePumpingDto dto,
  });

  /// Удалить заметку сцеживания.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/pumping/delete/notes')
  Future<void> deleteFeedPumpingDeleteNotes({
    @Body() required FeedDeletePumpingDto dto,
  });

  /// Удалить статистику кормления.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/food/delete/stats')
  Future<void> deleteFeedFoodDeleteStats({
    @Body() required FeedDeleteFoodDto dto,
  });

  /// Удалить заметку кормления.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/food/delete/notes')
  Future<void> deleteFeedFoodDeleteNotes({
    @Body() required FeedDeleteFoodDto dto,
  });

  /// Удалить статистику прикорма.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/lure/delete/stats')
  Future<void> deleteFeedLureDeleteStats({
    @Body() required FeedDeleteLureDto dto,
  });

  /// Удалить заметку прикорма.
  ///
  /// [dto] - DTO.
  @DELETE('/feed/lure/delete/notes')
  Future<void> deleteFeedLureDeleteNotes({
    @Body() required FeedDeleteLureDto dto,
  });

  /// Вывести таблицу.
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
  ///
  /// [sortType] - sort_type (new/old).
  @GET('/feed/table/{sort_type}')
  Future<FeedResponseHistoryTable> getFeedTableSortType({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Path('sort_type') String? sortType,
  });
}
