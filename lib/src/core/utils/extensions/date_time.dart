import 'package:mama/src/data.dart';

extension DateTimeExtension on DateTime {
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String timeRange(DateTime end) {
    return '$formattedTime - ${end.formattedTime}';
  }

  DateTime startOfWeek() {
    return DateTime.utc(year, month, day).subtract(Duration(days: weekday - 1));
  }

  String getTotalTime(DateTime? end) {
    if (end == null) return '\u221E';
    final duration = end.difference(this);
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours${t.trackers.hours} $minutes${t.trackers.min} $seconds${t.trackers.sec}';
    }
    return '$minutes${t.trackers.min} $seconds${t.trackers.sec}';
  }
}
