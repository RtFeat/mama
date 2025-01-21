extension DoubleExtension on num {
  String get toMinutes {
    final int minutes = (this / 60).floor();
    final int seconds = (this % 60).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
