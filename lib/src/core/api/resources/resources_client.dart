// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'resources_client.g.dart';

@RestApi()
abstract class ResourcesClient {
  factory ResourcesClient(Dio dio, {String? baseUrl}) = _ResourcesClient;

  /// Получить файл аватарки.
  ///
  /// Получить файл аватарки передавая uuid аватарки без расширения.
  ///
  /// [avatar] - Avatar.
  @GET('/resources/avatar/{avatar}')
  Future<void> getResourcesAvatarAvatar({
    @Path('avatar') required String avatar,
  });
}
