import 'dart:async';

import 'package:ispect/ispect.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

final iSpectify = ISpectify(options: ISpectifyOptions());

void main() {
  ISpect.run(
    () => logger.runLogging(
        () => runZonedGuarded(
              () => const AppRunner().initializeAndRun(),
              logger.logZoneError,
            ),
        const LogOptions()),
    logger: iSpectify,
  );
}
