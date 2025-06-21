// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user_me_response.dart';
import '../models/user_update_dto.dart';

part 'user_client.g.dart';

@RestApi()
abstract class UserClient {
  factory UserClient(Dio dio, {String? baseUrl}) = _UserClient;

  /// Изменить данные пользователя.
  ///
  /// Изменить данные пользователя опционально.
  ///
  /// [dto] - DTO update user.
  @PATCH('/user/')
  Future<void> patchUser({
    @Body() required UserUpdateDto dto,
  });

  /// Мои данные профиля
  @GET('/user/me')
  Future<UserMeResponse> getUserMe();
}
