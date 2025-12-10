// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/watcher_response_get_watcher.dart';

part 'watcher_client.g.dart';

@RestApi()
abstract class WatcherClient {
  factory WatcherClient(Dio dio, {String? baseUrl}) = _WatcherClient;

  /// Получить данные обзора помощи
  @GET('/watcher/me')
  Future<WatcherResponseGetWatcher> getWatcherMe();

  /// Убрать узнать больше.
  ///
  /// [typeOfWatch] - Type of watch.
  @GET('/watcher/{typeOfWatch}')
  Future<void> getWatcherTypeOfWatch({
    @Path('typeOfWatch') required String typeOfWatch,
  });
}
