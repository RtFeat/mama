import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skit/skit.dart';

/// Dependencies container
base class Dependencies {
  const Dependencies({
    required this.sharedPreferences,
    required this.settingsStore,
    // required this.errorTrackingManager,
    required this.apiClient,
    required this.tokenStorage,
    required this.faker,
  });

  /// [SharedPreferences] instance, used to store Key-Value pairs.
  final SharedPreferences sharedPreferences;

  /// [SettingsStore] instance, used to manage theme and locale.
  final SettingsStore settingsStore;

  /// [FlutterSecureStorage] instance, used to store tokens.
  final Fresh<OAuth2Token> tokenStorage;

  /// [Faker] instance, used to generate fake data.
  final Faker faker;

  // /// [ErrorTrackingManager] instance, used to report errors.
  // final ErrorTrackingManager errorTrackingManager;

  /// [ApiClient] instance, used to make requests.
  final ApiClient apiClient;
}

/// Result of initialization
final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => '$InitializationResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
