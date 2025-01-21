import 'package:flutter/material.dart';

class DayOfWeek {
  final int day;
  final List<Events> events;
  final String? consultationId;

  DayOfWeek({
    required this.day,
    required this.events,
    this.consultationId,
  });
}

class Events {
  final int event;
  final Color fillColor;
  final Color textColor;

  Events(
      {required this.event, required this.fillColor, required this.textColor});
}
