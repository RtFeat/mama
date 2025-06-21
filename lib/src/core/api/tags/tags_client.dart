// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/entity_tag.dart';
import '../models/tags_create_dto.dart';
import '../models/tags_response_tags.dart';
import '../models/tags_set_dto.dart';
import '../models/tags_unset_dto.dart';

part 'tags_client.g.dart';

@RestApi()
abstract class TagsClient {
  factory TagsClient(Dio dio, {String? baseUrl}) = _TagsClient;

  /// Get tags.
  ///
  /// Get tags.
  ///
  /// [q] - Search query.
  ///
  /// [limit] - Limit.
  ///
  /// [offset] - Offset.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/tags/')
  Future<TagsResponseTags> getTags({
    @Query('q') String? q,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Create tag.
  ///
  /// Create tag.
  ///
  /// [dto] - Tag create.
  @POST('/tags/')
  Future<void> postTags({
    @Body() required TagsCreateDto dto,
  });

  /// Unset tag.
  ///
  /// Unset tag for article.
  ///
  /// [dto] - Tag unset.
  @DELETE('/tags/')
  Future<void> deleteTags({
    @Body() required TagsUnsetDto dto,
  });

  /// Set tag.
  ///
  /// Set tag for article.
  ///
  /// [dto] - Tag set.
  @PATCH('/tags/')
  Future<void> patchTags({
    @Body() required TagsSetDto dto,
  });

  /// Get article tags.
  ///
  /// Get article tags.
  ///
  /// [id] - Article id.
  ///
  /// [page] - Page.
  ///
  /// [pageSize] - Page size.
  @GET('/tags/article/{id}')
  Future<TagsResponseTags> getTagsArticleId({
    @Path('id') required String id,
    @Query('page') int? page,
    @Query('page_size') int? pageSize,
  });

  /// Delete tag.
  ///
  /// Delete tag.
  ///
  /// [id] - Tag id.
  @DELETE('/tags/{id}')
  Future<void> deleteTagsId({
    @Path('id') required String id,
  });

  /// Get tag.
  ///
  /// Get tag.
  ///
  /// [name] - Tag name.
  @GET('/tags/{name}')
  Future<EntityTag> getTagsName({
    @Path('name') required String name,
  });
}
