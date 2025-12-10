// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'account_avatar/account_avatar_client.dart';
import 'author/author_client.dart';
import 'category/category_client.dart';
import 'chat/chat_client.dart';
import 'child/child_client.dart';
import 'diaper/diaper_client.dart';
import 'feed/feed_client.dart';
import 'feedback/feedback_client.dart';
import 'geo/geo_client.dart';
import 'growth/growth_client.dart';
import 'health/health_client.dart';
import 'music/music_client.dart';
import 'notification/notification_client.dart';
import 'online_school/online_school_client.dart';
import 'payment/payment_client.dart';
import 'pdf/pdf_client.dart';
import 'resources/resources_client.dart';
import 'sleep_cry/sleep_cry_client.dart';
import 'tags/tags_client.dart';
import 'user/user_client.dart';
import 'watcher/watcher_client.dart';

/// API `v1.0`.
///
/// This is an auto-generated API Docs.
class RestClient {
  RestClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0';

  AccountAvatarClient? _accountAvatar;
  AuthorClient? _author;
  CategoryClient? _category;
  ChatClient? _chat;
  ChildClient? _child;
  DiaperClient? _diaper;
  FeedClient? _feed;
  FeedbackClient? _feedback;
  GeoClient? _geo;
  GrowthClient? _growth;
  HealthClient? _health;
  MusicClient? _music;
  NotificationClient? _notification;
  OnlineSchoolClient? _onlineSchool;
  PaymentClient? _payment;
  PdfClient? _pdf;
  ResourcesClient? _resources;
  SleepCryClient? _sleepCry;
  TagsClient? _tags;
  UserClient? _user;
  WatcherClient? _watcher;

  AccountAvatarClient get accountAvatar =>
      _accountAvatar ??= AccountAvatarClient(_dio, baseUrl: _baseUrl);

  AuthorClient get author => _author ??= AuthorClient(_dio, baseUrl: _baseUrl);

  CategoryClient get category =>
      _category ??= CategoryClient(_dio, baseUrl: _baseUrl);

  ChatClient get chat => _chat ??= ChatClient(_dio, baseUrl: _baseUrl);

  ChildClient get child => _child ??= ChildClient(_dio, baseUrl: _baseUrl);

  DiaperClient get diaper => _diaper ??= DiaperClient(_dio, baseUrl: _baseUrl);

  FeedClient get feed => _feed ??= FeedClient(_dio, baseUrl: _baseUrl);

  FeedbackClient get feedback =>
      _feedback ??= FeedbackClient(_dio, baseUrl: _baseUrl);

  GeoClient get geo => _geo ??= GeoClient(_dio, baseUrl: _baseUrl);

  GrowthClient get growth => _growth ??= GrowthClient(_dio, baseUrl: _baseUrl);

  HealthClient get health => _health ??= HealthClient(_dio, baseUrl: _baseUrl);

  MusicClient get music => _music ??= MusicClient(_dio, baseUrl: _baseUrl);

  NotificationClient get notification =>
      _notification ??= NotificationClient(_dio, baseUrl: _baseUrl);

  OnlineSchoolClient get onlineSchool =>
      _onlineSchool ??= OnlineSchoolClient(_dio, baseUrl: _baseUrl);

  PaymentClient get payment =>
      _payment ??= PaymentClient(_dio, baseUrl: _baseUrl);

  PdfClient get pdf => _pdf ??= PdfClient(_dio, baseUrl: _baseUrl);

  ResourcesClient get resources =>
      _resources ??= ResourcesClient(_dio, baseUrl: _baseUrl);

  SleepCryClient get sleepCry =>
      _sleepCry ??= SleepCryClient(_dio, baseUrl: _baseUrl);

  TagsClient get tags => _tags ??= TagsClient(_dio, baseUrl: _baseUrl);

  UserClient get user => _user ??= UserClient(_dio, baseUrl: _baseUrl);

  WatcherClient get watcher =>
      _watcher ??= WatcherClient(_dio, baseUrl: _baseUrl);
}
