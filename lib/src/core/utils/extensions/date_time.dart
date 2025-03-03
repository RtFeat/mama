extension DateTimeExtension on DateTime {
  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String timeRange(DateTime end) {
    return '$formattedTime - ${end.formattedTime}';
  }

  DateTime startOfWeek() {
    return DateTime.utc(year, month, day).subtract(Duration(days: weekday - 1));
  }
}
