import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class CalendarUtils {
  static List<List<DayOfWeek>> generateCalendarData(DateTime month) {
    // Первый и последний день месяца
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // День недели первого и последнего дней месяца
    final firstWeekday = firstDayOfMonth.weekday; // 1 - понедельник
    final lastWeekday = lastDayOfMonth.weekday; // 7 - воскресенье

    // Начальная дата календаря (включая дни предыдущего месяца)
    final startDate =
        firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));

    // Конечная дата календаря (включая дни следующего месяца)
    final endDate = lastDayOfMonth.add(Duration(days: 7 - lastWeekday));

    // Генерация списка дней
    final days = <DayOfWeek>[];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      days.add(DayOfWeek(
        day: currentDate.day,
        events: currentDate.month == month.month
            ? _generateEventsForDay(
                currentDate) // События только для текущего месяца
            : [],
      ));
      currentDate = currentDate.add(Duration(days: 1));
    }

    // Группировка дней по неделям
    final weeks = <List<DayOfWeek>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return weeks;
  }

  static List<Events> _generateEventsForDay(DateTime day) {
    // Пример генерации событий для определённых дней
    if (day.day % 5 == 0) {
      return [
        Events(
            event: day.day, fillColor: Colors.green, textColor: Colors.white),
      ];
    }
    return [];
  }
}
