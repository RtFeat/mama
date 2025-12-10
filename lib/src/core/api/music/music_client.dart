// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/music_update_dto.dart';

part 'music_client.g.dart';

@RestApi()
abstract class MusicClient {
  factory MusicClient(Dio dio, {String? baseUrl}) = _MusicClient;

  /// Обновить статус музыки.
  ///
  /// [musicName] - DTO.
  @PATCH('/music/')
  Future<void> patchMusic({
    @Body() required MusicUpdateDto musicName,
  });

  /// Вывести всю музыку согласно категории.
  ///
  /// [music] - Category.
  @GET('/music/descriptions/{music}')
  Future<void> getMusicDescriptionsMusic({
    @Path('music') required String music,
  });

  /// Получить одну песню.
  ///
  /// [id] - ID.
  @GET('/music/{id}')
  Future<void> getMusicId({
    @Path('id') required String id,
  });
}
