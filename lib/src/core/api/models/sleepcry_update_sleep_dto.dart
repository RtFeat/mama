// coverage:ignore-file
// Manual DTO (no codegen) to support full PATCH payload for /sleep_cry/sleep/stats
// ignore_for_file: type=lint

class SleepcryUpdateSleepDto {
  const SleepcryUpdateSleepDto({
    required this.id,
    this.allSleep,
    this.timeEnd,
    this.timeToEnd,
    this.timeToStart,
    this.notes,
  });

  final String id;
  // maps to all_sleep
  final String? allSleep;
  // maps to time_end (ISO8601 Zulu)
  final DateTime? timeEnd;
  // maps to time_to_end (HH:mm)
  final String? timeToEnd;
  // maps to time_to_start (HH:mm)
  final String? timeToStart;
  // optional notes
  final String? notes;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      if (allSleep != null) 'all_sleep': allSleep,
      if (timeEnd != null) 'time_end': timeEnd!.toUtc().toIso8601String(),
      if (timeToEnd != null) 'time_to_end': timeToEnd,
      if (timeToStart != null) 'time_to_start': timeToStart,
      if (notes != null) 'notes': notes,
    };
  }
}
