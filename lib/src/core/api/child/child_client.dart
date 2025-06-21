// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/child_create_dto.dart';
import '../models/child_delete_avatar.dart';
import '../models/child_delete_dto.dart';
import '../models/child_status_response.dart';
import '../models/child_update_avatar_response.dart';
import '../models/child_update_dto.dart';
import '../models/entity_child.dart';

part 'child_client.g.dart';

@RestApi()
abstract class ChildClient {
  factory ChildClient(Dio dio, {String? baseUrl}) = _ChildClient;

  /// Добавить ребенка.
  ///
  /// Добавить ребенка c обязательными полями FirstName, Weight, Height, HeadCirc.
  ///
  /// [dto] - DTO.
  @POST('/child/')
  Future<void> postChild({
    @Body() required ChildCreateDto dto,
  });

  /// Удалить ребенка.
  ///
  /// [dto] - DTO.
  @DELETE('/child/')
  Future<void> deleteChild({
    @Body() required ChildDeleteDto dto,
  });

  /// Изменить данные ребенка.
  ///
  /// Нужно передать birth_date(дата рождения) чтобы определить группу чата.
  /// Нужно передать id ребенка, и поля которые нужно изменить.
  ///
  /// [dto] - DTO.
  @PATCH('/child/')
  Future<void> patchChild({
    @Body() required ChildUpdateDto dto,
  });

  /// Изменить аватарку.
  ///
  /// [childId] - Child ID.
  ///
  /// [avatar] - Avatar.
  @PUT('/child/avatar/')
  Future<ChildUpdateAvatarResponse> putChildAvatar({
    @Part(name: 'child_id') required String childId,
    @Part(name: 'avatar') required File avatar,
  });

  /// Удалить аватарку.
  ///
  /// [dto] - DTO delete avatar.
  @DELETE('/child/avatar/')
  Future<void> deleteChildAvatar({
    @Body() required ChildDeleteAvatar dto,
  });

  /// Получить статус ребенка по child_id.
  ///
  /// [id] - ID.
  @GET('/child/status/{id}')
  Future<ChildStatusResponse> getChildStatusId({
    @Path('id') required String id,
  });

  /// Получить ребенка по ID.
  ///
  /// [id] - ID.
  @GET('/child/{id}')
  Future<EntityChild> getChildId({
    @Path('id') required String id,
  });
}
