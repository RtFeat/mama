// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/geo_cities_response.dart';
import '../models/geo_countries_response.dart';

part 'geo_client.g.dart';

@RestApi()
abstract class GeoClient {
  factory GeoClient(Dio dio, {String? baseUrl}) = _GeoClient;

  /// Получить список городов.
  ///
  /// [q] - Query.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [countryId] - Country ID.
  @GET('/geo/city')
  Future<GeoCitiesResponse> getGeoCity({
    @Query('limit') required String limit,
    @Query('q') String? q,
    @Query('offset') String? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('country_id') String? countryId,
  });

  /// Получить список стран.
  ///
  /// [q] - Query.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/geo/country')
  Future<GeoCountriesResponse> getGeoCountry({
    @Query('limit') required String limit,
    @Query('q') String? q,
    @Query('offset') String? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });
}
