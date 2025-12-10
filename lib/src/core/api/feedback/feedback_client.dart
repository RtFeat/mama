// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/feedback_chat_response.dart';
import '../models/feedback_create_dto.dart';
import '../models/feedback_response_create.dart';

part 'feedback_client.g.dart';

@RestApi()
abstract class FeedbackClient {
  factory FeedbackClient(Dio dio, {String? baseUrl}) = _FeedbackClient;

  /// Создать feedback.
  ///
  /// Создать feedback.
  ///
  /// [dto] - DTO.
  @POST('/feedback/')
  Future<FeedbackResponseCreate> postFeedback({
    @Body() required FeedbackCreateDto dto,
  });

  /// Перейти в чат с пользователем
  @GET('/feedback/go_chat')
  Future<FeedbackChatResponse> getFeedbackGoChat();
}
