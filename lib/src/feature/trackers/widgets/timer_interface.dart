import 'package:flutter/material.dart';

/// Абстрактный интерфейс для работы с таймерами
abstract class TimerInterface {
  DateTime get timerStartTime;
  DateTime? get timerEndTime;
  DateTime? get pauseTime;
  bool get timerSleepStart;
  void updateStartTime(DateTime? value);
  void updateEndTime(DateTime? value);
}
