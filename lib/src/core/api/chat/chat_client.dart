// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/chat_all_chats_response.dart';
import '../models/chat_chat_response.dart';
import '../models/chat_chats_response.dart';
import '../models/chat_file_response.dart';
import '../models/chat_get_chat_with_user_dto.dart';
import '../models/chat_group_chats_response.dart';
import '../models/chat_messages_response.dart';
import '../models/chat_response_get_all_specialists_in_chats.dart';
import '../models/chat_response_get_all_users_in_chats.dart';
import '../models/chat_search_dto.dart';
import '../models/chat_search_in_chat_resp.dart';
import '../models/chat_upload_response.dart';

part 'chat_client.g.dart';

@RestApi()
abstract class ChatClient {
  factory ChatClient(Dio dio, {String? baseUrl}) = _ChatClient;

  /// Получить список одиночных чатов.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/chat')
  Future<ChatChatsResponse> getChat({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Получить список всех чатов.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - Child ID.
  @GET('/chat/all')
  Future<ChatAllChatsResponse> getChatAll({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('child_id') String? childId,
  });

  /// Создать или получить чат по ID собеседника.
  ///
  /// [dto] - DTO.
  @POST('/chat/create')
  Future<ChatChatResponse> postChatCreate({
    @Body() required ChatGetChatWithUserDto dto,
  });

  /// Получить список групповых чатов.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  ///
  /// [childId] - Child ID.
  @GET('/chat/group')
  Future<ChatGroupChatsResponse> getChatGroup({
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
    @Query('child_id') String? childId,
  });

  /// Получить всех юзеров(специалисты отдельно) чата.
  ///
  /// [chatId] - groups_chat_id.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/chat/groups/all/{chat_id}')
  Future<ChatResponseGetAllUsersInChats> getChatGroupsAllChatId({
    @Path('chat_id') required String chatId,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Получить всех специалистов(юзеры отдельно) чата.
  ///
  /// [chatId] - groups_chat_id.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/chat/groups/allSpecialists/{chat_id}')
  Future<ChatResponseGetAllSpecialistsInChats> getChatGroupsAllSpecialistsChatId({
    @Path('chat_id') required String chatId,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Отправить сообщение с каким-то либо файлом.
  ///
  /// [file] - File.
  ///
  /// [message] - Message with file.
  ///
  /// [chatId] - chat_id.
  ///
  /// [typeChat] - group or solo chat.
  ///
  /// [reply] - reply.
  @MultiPart()
  @POST('/chat/message/file/{chat_id}')
  Future<ChatFileResponse> postChatMessageFileChatId({
    @Path('chat_id') required String chatId,
    @Part(name: 'type_chat') required String typeChat,
    @Part(name: 'file') List<File>? file,
    @Part(name: 'message') String? message,
    @Part(name: 'reply') String? reply,
  });

  /// Получить файл.
  ///
  /// [filepath] - FilePath with type!
  @GET('/chat/message/file/{filepath}')
  Future<void> getChatMessageFileFilepath({
    @Path('filepath') required String filepath,
  });

  /// Поиск сообщения в чате.
  ///
  /// [text] - Query.
  ///
  /// [dto] - searchDTO.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  @POST('/chat/message/search')
  Future<ChatSearchInChatResp> postChatMessageSearch({
    @Body() required ChatSearchDto dto,
    @Query('limit') required String limit,
    @Query('text') String? text,
    @Query('offset') String? offset,
  });

  /// Получить список сообщений в чате.
  ///
  /// [chatId] - Chat ID.
  ///
  /// [typeChat] - solo or group chat.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  @GET('/chat/message/{type_chat}')
  Future<ChatMessagesResponse> getChatMessageTypeChat({
    @Query('chat_id') required String chatId,
    @Path('type_chat') required String typeChat,
    @Query('limit') String? limit,
    @Query('offset') String? offset,
  });

  /// Получить файл аватарки чата.
  ///
  /// Получить файл аватарки передавая uuid аватарки без расширения.
  ///
  /// [avatar] - Avatar.
  @GET('/chat/resources/avatar/{avatar}')
  Future<void> getChatResourcesAvatarAvatar({
    @Path('avatar') required String avatar,
  });

  /// Загрузить файл.
  ///
  /// [file] - File.
  @MultiPart()
  @POST('/chat/upload')
  Future<ChatUploadResponse> postChatUpload({
    @Part(name: 'file') List<File>? file,
  });
}
