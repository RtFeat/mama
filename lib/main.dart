import 'dart:async';

import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
