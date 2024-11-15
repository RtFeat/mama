import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

import '../data/data.dart';

class CalendarCell extends StatelessWidget {
  final DayOfWeek data;

  const CalendarCell({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Column(
      children: [
        Text(
          data.day.toString(),
          style: textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w400, color: Colors.black),
        ),
        5.h,
        data.events.isEmpty
            ? const Expanded(child: SizedBox())
            : Expanded(
                child: Column(
                  children: data.events
                      .map((c) => _CellContainer(
                            data: c,
                          ))
                      .toList(),
                ),
              ),
        5.h
      ],
    );
  }
}

class _CellContainer extends StatelessWidget {
  final Events data;

  const _CellContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Container(
          width: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: data.fillColor),
          child: Center(
            child: Text(
              data.event.toString(),
              style: textTheme.labelSmall?.copyWith(color: data.textColor),
            ),
          ),
        ),
      ),
    );
  }
}
