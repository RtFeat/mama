import 'package:mama/src/feature/initialization/model/environment.dart';
import 'package:skit/skit.dart';

/// Application AppConfiguration
class AppConfig extends Config {
  /// Creates a new [AppConfig] instance.
  const AppConfig();

  /// The current environment.
  Environment get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');

    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');

    return Environment.from(environment);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;

  /// The API URL.
  @override
  String get apiUrl => const String.fromEnvironment(
        'API_URL',
        defaultValue: 'https://api.mama-api.ru/api/v1/',
      );
}
