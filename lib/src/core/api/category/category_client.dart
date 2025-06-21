// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/category_insert_category_dto.dart';
import '../models/category_response_dto.dart';
import '../models/category_response_list_of_age_category.dart';
import '../models/category_response_list_of_category.dart';

part 'category_client.g.dart';

@RestApi()
abstract class CategoryClient {
  factory CategoryClient(Dio dio, {String? baseUrl}) = _CategoryClient;

  /// Получить весь список категорий.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/category')
  Future<CategoryResponseListOfCategory> getCategory({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Добавить категорию.
  ///
  /// [dto] - Add category.
  @POST('/category/')
  Future<CategoryResponseDto> postCategory({
    @Body() required CategoryInsertCategoryDto dto,
  });

  /// Получить весь список возрастных категорий.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/category/age')
  Future<CategoryResponseListOfAgeCategory> getCategoryAge({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Добавить категорию по возрасту.
  ///
  /// [dto] - Add age category.
  @POST('/category/age')
  Future<CategoryResponseDto> postCategoryAge({
    @Body() required CategoryInsertCategoryDto dto,
  });
}
