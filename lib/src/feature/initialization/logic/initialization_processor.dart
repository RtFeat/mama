import 'package:dio/dio.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ispectify_dio/ispectify_dio.dart' as ispect;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skit/skit.dart';
import 'package:televerse/televerse.dart';

import 'package:mama/main.dart';
import 'package:mama/src/data.dart';

final class InitializationProcessor {
  const InitializationProcessor(this.appConfig);

  /// Application AppConfiguration
  final AppConfig appConfig;

  Future<Dependencies> _initDependencies() async {
    final ID chatId = ChatID(958930260);

    final sharedPreferences = await SharedPreferences.getInstance();

    await FlutterDownloader.initialize(
      debug: kDebugMode,
      ignoreSsl: true,
    );

    await Firebase.initializeApp();

    final storage = AuthStorageImpl(
      storage: const FlutterSecureStorage(),
    );

    final tokenStorage = Fresh.oAuth2(
      tokenStorage: storage,
      refreshToken: (token, client) async {
        final response = await client.get(
          '${const AppConfig().apiUrl}${Endpoint().accessToken}',
          options: Options(
            headers: {'Refresh-Token': 'Bearer ${token?.refreshToken}'},
            followRedirects: true,
            contentType: 'application/json',
            responseType: ResponseType.json,
          ),
        );

        return OAuth2Token(
          accessToken: response.data['access_token'],
          refreshToken: response.data['refresh_token'],
        );
      },
    );

    final dio = await _initDio(tokenStorage);

    final apiClient =
        ApiClientDio(baseUrl: const AppConfig().apiUrl, dio: dio);

    final restClient = RestClient(
      dio,
      baseUrl: AppConfig().apiUrl,
    );

    final settingsStore = await _initSettingsStore(sharedPreferences);

    final Faker faker = Faker.instance;

    // Televerse Bot
    final bot = Bot(
      '6621512389:AAF19-MPs9wV9z5FNnaKetcML85SR2xkGlw',
    );

    // FlutterError -> Telegram
    FlutterError.onError = (details) async {
      if (kDebugMode) return;

      final msg = '''
🚨 Project: Mama&Co
Flutter error:
${details.exception.toString().limit(150)}
Stack trace:
${details.stack.toString().limit(300)}
''';

      await bot.api.sendMessage(chatId, msg);
    };

    return Dependencies(
      imagePicker: ImagePicker(),
      faker: faker,
      bot: bot,
      sharedPreferences: sharedPreferences,
      settingsStore: settingsStore,
      apiClient: apiClient,
      tokenStorage: tokenStorage,
      restClient: restClient,
    );
  }

  Future<SettingsStore> _initSettingsStore(
    SharedPreferences prefs,
  ) async {
    final localeRepository = LocaleRepositoryImpl(
      localeDataSource: LocaleDataSourceLocal(
        sharedPreferences: prefs,
      ),
    );

    final themeRepository = ThemeRepositoryImpl(
      themeDataSource: ThemeDataSourceLocal(
        sharedPreferences: prefs,
        codec: const ThemeModeCodec(),
      ),
    );

    final localeFuture = localeRepository.getLocale();
    final theme = await themeRepository.getTheme();

    final themeStore = ThemeStore(
      mode: theme?.mode ?? ThemeMode.system,
      seed: theme?.seed ?? AppColors.primaryColor,
    );

    final locale = await localeFuture;

    final settingsStore = DefaultSettingsStore(
      localeRepository: localeRepository,
      themeRepository: themeRepository,
      locale: locale ?? Locale(Intl.systemLocale),
      appTheme: themeStore,
    );

    settingsStore
      ..setTheme(themeStore)
      ..setLocale(locale ?? Locale(Intl.systemLocale));

    return settingsStore;
  }

  /// Dio с авторизацией и логгером
  Future<Dio> _initDio(Fresh storage) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: const AppConfig().apiUrl,
        followRedirects: true,
      ),
    );

    dio.interceptors.add(storage);

    // ✅ совместимая версия логгера под ispectify_dio 4.4.7
    dio.interceptors.add(
      ispect.ISpectDioInterceptor(
        settings: const ispect.ISpectDioInterceptorSettings(
          enabled: true,
          printRequestHeaders: true,
          printRequestData: true,
          printResponseData: true,
          printErrorData: true,
        ),
      ),
    );

    return dio;
  }

  /// Точка входа в инициализацию
  Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');

    stopwatch.stop();
    return InitializationResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
  }
}
