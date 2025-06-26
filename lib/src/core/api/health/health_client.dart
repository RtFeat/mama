// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/health_completed_drug.dart';
import '../models/health_delete_cons_doctor.dart';
import '../models/health_delete_drug.dart';
import '../models/health_delete_vaccination.dart';
import '../models/health_insert_temperature_dto.dart';
import '../models/health_respone_list_doc_vaccination.dart';
import '../models/health_response_insert_dto.dart';
import '../models/health_response_list_cons_doctor.dart';
import '../models/health_response_list_drug.dart';
import '../models/health_response_list_vaccination.dart';

part 'health_client.g.dart';

@RestApi()
abstract class HealthClient {
  factory HealthClient(Dio dio, {String? baseUrl}) = _HealthClient;

  /// Добавить поход к врачу.
  ///
  /// [photo] - photo.
  ///
  /// [childId] - child_id.
  ///
  /// [dataStart] - дата начала example:'2024-02-15 00:00:00.000'.
  ///
  /// [doctor] - doctor.
  ///
  /// [clinic] - clinic.
  ///
  /// [notes] - notes.
  @POST('/health/cons_doctor')
  Future<void> postHealthConsDoctor({
    @Part(name: 'child_id') required String childId,
    @Part(name: 'photo') File? photo,
    @Part(name: 'data_start') String? dataStart,
    @Part(name: 'doctor') String? doctor,
    @Part(name: 'clinic') String? clinic,
    @Part(name: 'notes') String? notes,
  });

  /// Изменить данные визита к врачу.
  ///
  /// [photo] - photo.
  ///
  /// [id] - id.
  ///
  /// [dataStart] - дата начала example:'2024-02-15 00:00:00.000'.
  ///
  /// [doctor] - doctor.
  ///
  /// [clinic] - clinic.
  ///
  /// [notes] - notes start.
  @PATCH('/health/cons_doctor')
  Future<void> patchHealthConsDoctor({
    @Part(name: 'id') required String id,
    @Part(name: 'photo') File? photo,
    @Part(name: 'data_start') String? dataStart,
    @Part(name: 'doctor') String? doctor,
    @Part(name: 'clinic') String? clinic,
    @Part(name: 'notes') String? notes,
  });

  /// Удалить консультация к врачу.
  ///
  /// [dto] - DTO delete cons doctor.
  @DELETE('/health/cons_doctor/')
  Future<void> deleteHealthConsDoctor({
    @Body() required HealthDeleteConsDoctor dto,
  });

  /// Вывести все запись к врачу.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - child id.
  @GET('/health/cons_doctor/list')
  Future<HealthResponseListConsDoctor> getHealthConsDoctorList({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Получить изображение визита к врачу.
  ///
  /// [avatar] - Avatar.
  @GET('/health/cons_doctor/{avatar}')
  Future<void> getHealthConsDoctorAvatar({
    @Path('avatar') required String avatar,
  });

  /// Получить список документов вакцинации
  @GET('/health/doc_vaccination')
  Future<HealthResponeListDocVaccination> getHealthDocVaccination();

  /// Добавить документ вакцинации.
  ///
  /// [photo] - doc.
  ///
  /// [name] - name.
  ///
  /// [childId] - child_id.
  @MultiPart()
  @POST('/health/doc_vaccination')
  Future<void> postHealthDocVaccination({
    @Part(name: 'name') required String name,
    @Part(name: 'child_id') required String childId,
    @Part(name: 'photo') File? photo,
  });

  /// Получить изображение документа вакцинации.
  ///
  /// [avatar] - Avatar.
  @GET('/health/doc_vaccination/{avatar}')
  Future<void> getHealthDocVaccinationAvatar({
    @Path('avatar') required String avatar,
  });

  /// Добавить лекарство.
  ///
  /// [photo] - photo.
  ///
  /// [childId] - Child id.
  ///
  /// [nameDrug] - Name of drug.
  ///
  /// [dose] - dose.
  ///
  /// [notes] - Notes.
  ///
  /// [dataStart] - Data start example:'2024-02-15 00:00:00.000'.
  ///
  /// [isEnd] - Is end.
  ///
  /// [reminder] - reminder example:'20:00:00'.
  @POST('/health/drug')
  Future<void> postHealthDrug({
    @Part(name: 'child_id') required String childId,
    @Part(name: 'data_start') required String dataStart,
    @Part(name: 'photo') File? photo,
    @Part(name: 'name_drug') String? nameDrug,
    @Part(name: 'dose') String? dose,
    @Part(name: 'notes') String? notes,
    @Part(name: 'is_end') bool? isEnd,
    @Part(name: 'reminder') String? reminder,
  });

  /// Изменить данные лекарства reminder = 20:00:00.
  ///
  /// [photo] - photo.
  ///
  /// [id] - drug id.
  ///
  /// [nameDrug] - Name of drug.
  ///
  /// [dose] - dose.
  ///
  /// [notes] - Notes.
  ///
  /// [dataStart] - Data start example:'2024-02-15 00:00:00.000'.
  ///
  /// [dataEnd] - Data end example:'2024-02-15 00:00:00.000'.
  ///
  /// [isEnd] - Is end.
  ///
  /// [reminder] - reminder example:'20:00:00'.
  @PATCH('/health/drug')
  Future<void> patchHealthDrug({
    @Part(name: 'id') required String id,
    @Part(name: 'photo') File? photo,
    @Part(name: 'name_drug') String? nameDrug,
    @Part(name: 'dose') String? dose,
    @Part(name: 'notes') String? notes,
    @Part(name: 'data_start') String? dataStart,
    @Part(name: 'data_end') String? dataEnd,
    @Part(name: 'is_end') bool? isEnd,
    @Part(name: 'reminder') String? reminder,
  });

  /// Удалить лекарство.
  ///
  /// [dto] - DTO delete drug.
  @DELETE('/health/drug/')
  Future<void> deleteHealthDrug({
    @Body() required HealthDeleteDrug dto,
  });

  /// поменять состояние лекарства на завершенное.
  ///
  /// [dto] - DTO completed drug.
  @PATCH('/health/drug/completed')
  Future<void> patchHealthDrugCompleted({
    @Body() required HealthCompletedDrug dto,
  });

  /// Вывести все лекарство ребенка.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - child id.
  @GET('/health/drug/list')
  Future<HealthResponseListDrug> getHealthDrugList({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Получить изображение лекарства.
  ///
  /// [avatar] - Avatar.
  @GET('/health/drug/{avatar}')
  Future<void> getHealthDrugAvatar({
    @Path('avatar') required String avatar,
  });

  /// Получить файл с идеальным графиков прививок
  @GET('/health/ideal')
  Future<void> getHealthIdeal();

  /// Получить файл с рекомендуемым графиков прививок
  @GET('/health/normal')
  Future<void> getHealthNormal();

  /// Добавить показатель температуры.
  ///
  /// [dto] - Add temperature.
  @POST('/health/temperature')
  Future<HealthResponseInsertDto> postHealthTemperature({
    @Body() required HealthInsertTemperatureDto dto,
  });

  /// Добавить прививку.
  ///
  /// [photo] - photo.
  ///
  /// [childId] - child_id.
  ///
  /// [dataStart] - дата начала example:'2024-02-15 00:00:00.000'.
  ///
  /// [vaccinationName] - Vaccination.
  ///
  /// [clinic] - clinic.
  ///
  /// [notes] - notes.
  @POST('/health/vaccination')
  Future<void> postHealthVaccination({
    @Part(name: 'child_id') required String childId,
    @Part(name: 'data_start') required String dataStart,
    @Part(name: 'photo') File? photo,
    @Part(name: 'vaccination_name') String? vaccinationName,
    @Part(name: 'clinic') String? clinic,
    @Part(name: 'notes') String? notes,
  });

  /// Изменить данные прививки.
  ///
  /// [photo] - photo.
  ///
  /// [id] - id.
  ///
  /// [dataStart] - дата начала example:'2024-02-15 00:00:00.000'.
  ///
  /// [doctor] - doctor.
  ///
  /// [clinic] - clinic.
  ///
  /// [notes] - notes start.
  @PATCH('/health/vaccination')
  Future<void> patchHealthVaccination({
    @Part(name: 'id') required String id,
    @Part(name: 'photo') File? photo,
    @Part(name: 'data_start') String? dataStart,
    @Part(name: 'doctor') String? doctor,
    @Part(name: 'clinic') String? clinic,
    @Part(name: 'notes') String? notes,
  });

  /// Удалить прививку.
  ///
  /// [dto] - DTO delete vaccination.
  @DELETE('/health/vaccination/')
  Future<void> deleteHealthVaccination({
    @Body() required HealthDeleteVaccination dto,
  });

  /// Вывести все прививки.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - child id.
  @GET('/health/vaccination/list')
  Future<HealthResponseListVaccination> getHealthVaccinationList({
    @Query('child_id') required String childId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Получить изображение прививки.
  ///
  /// [avatar] - Avatar.
  @GET('/health/vaccination/{avatar}')
  Future<void> getHealthVaccinationAvatar({
    @Path('avatar') required String avatar,
  });
}
