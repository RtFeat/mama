import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart' as p;
import 'package:skit/skit.dart';

/// A class which is responsible for initialization and running the app.
final class AppRunner {
  const AppRunner();

  /// Start the initialization and in case of success run application
  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    p.LocaleSettings.useDeviceLocale();
    // LocaleSettings.setLocaleRaw('ru');

    // Preserve splash screen
    binding.deferFirstFrame();

    // Override logging
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError =
        logger.logPlatformDispatcherError;

    const appConfig = p.AppConfig();
    const initializationProcessor = p.InitializationProcessor(appConfig);

    Future<void> initializeAndRun() async {
      try {
        final result = await initializationProcessor.initialize();

        // Attach this widget to the root of the tree.
        runApp(p.App(result: result));
      } catch (e, stackTrace) {
        logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(
          p.InitializationFailedApp(
            error: e,
            stackTrace: stackTrace,
            retryInitialization: initializeAndRun,
          ),
        );
      } finally {
        // Allow rendering
        binding.allowFirstFrame();
      }
    }

    // Run the app
    await initializeAndRun();
  }
}
