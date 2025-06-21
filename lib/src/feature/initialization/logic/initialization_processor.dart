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
import 'package:ispectify_dio/ispectify_dio.dart';
import 'package:mama/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:televerse/televerse.dart';

final class InitializationProcessor {
  const InitializationProcessor(this.appConfig);

  /// Application AppConfiguration
  final AppConfig appConfig;

  Future<Dependencies> _initDependencies() async {
    final ID _chatId = ChatID(958930260);
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

    final dio = await _initDio(tokenStorage);
    final apiClient = ApiClientDio(baseUrl: const AppConfig().apiUrl, dio: dio);
    final restClient = RestClient(dio, baseUrl: AppConfig().apiUrl);
    // final errorTrackingManager = await _initErrorTrackingManager();
    final settingsStore = await _initSettingsStore(sharedPreferences);

    final Faker faker = Faker.instance;

    final bot = Bot(
      '6621512389:AAF19-MPs9wV9z5FNnaKetcML85SR2xkGlw',
      loggerOptions: LoggerOptions(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        methods: [
          APIMethod.sendMessage,
          APIMethod.sendPhoto,
        ],
      ),
    );
    FlutterError.onError = (e) {
      if (kDebugMode) {
        return;
      }
      bot.api.sendMessage(_chatId,
          'Project Mama&Co\nFlutter error:\n${e.exception.toString().limit(150)} \n${e.stack.toString().limit(300)}');
    };

    return Dependencies(
      imagePicker: ImagePicker(),
      faker: faker,
      bot: bot,
      sharedPreferences: sharedPreferences,
      settingsStore: settingsStore,
      // errorTrackingManager: errorTrackingManager,
      apiClient: apiClient,
      tokenStorage: tokenStorage,
      restClient: restClient,
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

  Future<Dio> _initDio(Fresh storage) async {
    final dio = Dio(BaseOptions(
      baseUrl: const AppConfig().apiUrl,
      followRedirects: true,
    ));
    // dio.interceptors.add(PrettyDioLogger(
    //     requestBody: true,
    //     request: true,
    //     responseBody: true,
    //     requestHeader: true));
    dio.interceptors.add(storage);

    dio.interceptors.add(
      ISpectifyDioLogger(
        iSpectify: iSpectify,
        settings: ISpectifyDioLoggerSettings(
          enabled: true,
          // requestFilter: (requestOptions) =>
          //     requestOptions.path != '/post3s/1',
          // responseFilter: (response) => response.statusCode != 404,
          // errorFilter: (response) => response.response?.statusCode != 404,
          // errorFilter: (response) {
          //   return (response.message?.contains('This exception was thrown because')) == false;
          // },
        ),
      ),
    );

    return dio;

    // return ApiClientDio(baseUrl: const AppConfig().apiUrl, dio: dio);
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
