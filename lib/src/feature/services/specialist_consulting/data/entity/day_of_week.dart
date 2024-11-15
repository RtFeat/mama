import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class DayOfWeek {
  final int day;
  final List<Events> events;

  DayOfWeek({required this.day, required this.events});
}

class Events {
  final int event;
  final Color fillColor;
  final Color textColor;

  Events(
      {required this.event, required this.fillColor, required this.textColor});
}