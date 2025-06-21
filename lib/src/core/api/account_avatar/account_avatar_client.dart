// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/account_update_avatar_response.dart';

part 'account_avatar_client.g.dart';

@RestApi()
abstract class AccountAvatarClient {
  factory AccountAvatarClient(Dio dio, {String? baseUrl}) = _AccountAvatarClient;

  /// Изменить аватарку.
  ///
  /// [avatar] - Avatar.
  @PUT('/account/avatar')
  Future<AccountUpdateAvatarResponse> putAccountAvatar({
    @Part(name: 'avatar') required File avatar,
  });

  /// Удалить аватарку
  @DELETE('/account/avatar')
  Future<void> deleteAccountAvatar();
}
