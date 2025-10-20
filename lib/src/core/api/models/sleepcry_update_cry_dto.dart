// coverage:ignore-file
// Manual DTO for PATCH /sleep_cry/cry/stats
// ignore_for_file: type=lint

class SleepcryUpdateCryDto {
  const SleepcryUpdateCryDto({
    required this.id,
    this.allCry,
    this.timeEnd,
    this.timeToEnd,
    this.timeToStart,
    this.notes,
  });

  final String id;
  final String? allCry; // maps to all_cry
  final DateTime? timeEnd; // maps to time_end (ISO8601Z)
  final String? timeToEnd; // HH:mm
  final String? timeToStart; // HH:mm
  final String? notes;

  Map<String, Object?> toJson() => <String, Object?>{
        'id': id,
        if (allCry != null) 'all_cry': allCry,
        if (timeEnd != null) 'time_end': timeEnd!.toUtc().toIso8601String(),
        if (timeToEnd != null) 'time_to_end': timeToEnd,
        if (timeToStart != null) 'time_to_start': timeToStart,
        if (notes != null) 'notes': notes,
      };
}


