// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'author_client.g.dart';

@RestApi()
abstract class AuthorClient {
  factory AuthorClient(Dio dio, {String? baseUrl}) = _AuthorClient;

  /// Получить список авторов музыкальных произведений.
  ///
  /// Получить список авторов.
  @GET('/author/list')
  Future<void> getAuthorList();
}
