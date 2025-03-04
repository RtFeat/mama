import 'package:dio/dio.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final class InitializationProcessor {
  const InitializationProcessor(this.appConfig);

  /// Application AppConfiguration
  final AppConfig appConfig;

  Future<Dependencies> _initDependencies() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);

    await Firebase.initializeApp();

    final storage = AuthStorageImpl(storage: const FlutterSecureStorage());

    final tokenStorage = Fresh.oAuth2(
        tokenStorage: storage,
        refreshToken: (token, client) async {
          return await client
              .get(
            '${const AppConfig().apiUrl}${Endpoint().accessToken}',
            options: Options(
              headers: {'Refresh-Token': 'Bearer ${token?.refreshToken}'},
              followRedirects: true,
              contentType: 'application/json',
              responseType: ResponseType.json,
            ),
          )
              .then((v) {
            return OAuth2Token(
                accessToken: v.data['access_token'],
                refreshToken: v.data['refresh_token']);
          });
        });

    final apiClient = await _initApiClient(tokenStorage);
    // final errorTrackingManager = await _initErrorTrackingManager();
    final settingsStore = await _initSettingsStore(sharedPreferences);

    final Faker faker = Faker.instance;

    return Dependencies(
      faker: faker,
      sharedPreferences: sharedPreferences,
      settingsStore: settingsStore,
      // errorTrackingManager: errorTrackingManager,
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    );
  }

  // Future<ErrorTrackingManager> _initErrorTrackingManager() async {
  //   final errorTrackingManager = SentryTrackingManager(
  //     logger,
  //     sentryDsn: AppConfig.sentryDsn,
  //     environment: AppConfig.environment.value,
  //   );

  //   if (AppConfig.enableSentry) {
  //     await errorTrackingManager.enableReporting();
  //   }

  //   return errorTrackingManager;
  // }

  Future<SettingsStore> _initSettingsStore(SharedPreferences prefs) async {
    final localeRepository = LocaleRepositoryImpl(
      localeDataSource: LocaleDataSourceLocal(sharedPreferences: prefs),
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
    settingsStore.setTheme(themeStore);
    settingsStore.setLocale(locale ?? Locale(Intl.systemLocale));

    return settingsStore;
  }

  // Initializes the REST client with the provided FlutterSecureStorage.

  Future<ApiClient> _initApiClient(Fresh storage) async {
    final dio = Dio(BaseOptions(
      baseUrl: const AppConfig().apiUrl,
      followRedirects: true,
    ));
    dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        request: true,
        responseBody: true,
        requestHeader: true));
    dio.interceptors.add(storage);

    return ApiClientDio(baseUrl: const AppConfig().apiUrl, dio: dio);
  }

  /// Initializes dependencies and returns the result of the initialization.
  ///
  /// This method may contain additional steps that need initialization
  /// before the application starts
  /// (for example, caching or enabling tracking manager)
  Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    // initialize dependencies
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');

    stopwatch.stop();
    final result = InitializationResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    return result;
  }
}
