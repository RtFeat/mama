// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/online_school_req_add_online_school.dart';
import '../models/online_school_resp_online_school_course.dart';
import '../models/online_school_resp_online_school_numbers.dart';
import '../models/online_school_response_online_school.dart';
import '../models/online_school_update_dto.dart';
import '../models/online_school_update_number_dto.dart';
import '../models/online_school_update_online_course_dto.dart';

part 'online_school_client.g.dart';

@RestApi()
abstract class OnlineSchoolClient {
  factory OnlineSchoolClient(Dio dio, {String? baseUrl}) = _OnlineSchoolClient;

  /// Получить данные профиля онлайн школы
  @GET('/online-school/')
  Future<OnlineSchoolResponseOnlineSchool> getOnlineSchool();

  /// Обновить данные профиля онлайн школы.
  ///
  /// [dto] - DTO.
  @PUT('/online-school/')
  Future<void> putOnlineSchool({
    @Body() required OnlineSchoolUpdateDto dto,
  });

  /// Получить данные профиля всех онлайн школ.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/online-school/all')
  Future<OnlineSchoolResponseOnlineSchool> getOnlineSchoolAll({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Обновить данные курсов школы.
  ///
  /// [dto] - DTO.
  @PUT('/online-school/course')
  Future<void> putOnlineSchoolCourse({
    @Body() required OnlineSchoolUpdateOnlineCourseDto dto,
  });

  /// Добавить курс к школе.
  ///
  /// [number] - Number.
  @POST('/online-school/course')
  Future<void> postOnlineSchoolCourse({
    @Body() required OnlineSchoolReqAddOnlineSchool number,
  });

  /// Удалить онлайн курс у школы.
  ///
  /// [id] - id.
  @DELETE('/online-school/course')
  Future<void> deleteOnlineSchoolCourse({
    @Query('id') required String id,
  });

  /// Получить сисок онлайн курсов для школы.
  ///
  /// [schoolId] - school_id.
  @GET('/online-school/course/all')
  Future<OnlineSchoolRespOnlineSchoolCourse> getOnlineSchoolCourseAll({
    @Query('school_id') required String schoolId,
  });

  /// Обновить данные телефона школы.
  ///
  /// [dto] - DTO.
  @PUT('/online-school/number')
  Future<void> putOnlineSchoolNumber({
    @Body() required OnlineSchoolUpdateNumberDto dto,
  });

  /// добавить номер к школе.
  ///
  /// [number] - Number.
  ///
  /// [onlineID] - Online school id.
  @POST('/online-school/number')
  Future<void> postOnlineSchoolNumber({
    @Query('number') required String number,
    @Query('onlineID') required String onlineID,
  });

  /// Удалить телефон у школы.
  ///
  /// [number] - number.
  @DELETE('/online-school/number')
  Future<void> deleteOnlineSchoolNumber({
    @Query('number') required String number,
  });

  /// Получить данные всех номеров школы.
  ///
  /// [schoolId] - school_id.
  @GET('/online-school/number/all')
  Future<OnlineSchoolRespOnlineSchoolNumbers> getOnlineSchoolNumberAll({
    @Query('school_id') required String schoolId,
  });

  /// Получить данные профиля онлайн школы по ID.
  ///
  /// [id] - ID.
  @GET('/online-school/{id}')
  Future<OnlineSchoolResponseOnlineSchool> getOnlineSchoolId({
    @Path('id') required String id,
  });
}
