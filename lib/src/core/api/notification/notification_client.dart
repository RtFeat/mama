// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notification_delete_dto.dart';
import '../models/notification_notifications_response.dart';

part 'notification_client.g.dart';

@RestApi()
abstract class NotificationClient {
  factory NotificationClient(Dio dio, {String? baseUrl}) = _NotificationClient;

  /// Получение списка всех уведомлений
  @GET('/notification/')
  Future<NotificationNotificationsResponse> getNotification();

  /// Удалить все уведомления
  @DELETE('/notification/delete-all/')
  Future<void> deleteNotificationDeleteAll();

  /// Удалить уведомление.
  ///
  /// [dto] - DTO.
  @DELETE('/notification/delete/')
  Future<void> deleteNotificationDelete({
    @Body() required NotificationDeleteDto dto,
  });

  /// Прочитать все уведомление
  @PUT('/notification/read-all/')
  Future<void> putNotificationReadAll();

  /// Прочитать уведомление по ID.
  ///
  /// [id] - ID.
  @PUT('/notification/read/')
  Future<void> putNotificationRead({
    @Query('id') required String id,
  });
}
