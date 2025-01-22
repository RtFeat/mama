import 'package:mama/src/data.dart';

class CalendarUtils {
  static List<List<DayOfWeek>> generateCalendarData(
      DateTime month, List<List<WorkSlot>> workSlots) {
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
                currentDate, workSlots) // События только для текущего месяца
            : [],
      ));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Группировка дней по неделям
    final weeks = <List<DayOfWeek>>[];
    for (var i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7 > days.length ? days.length : i + 7));
    }

    return weeks;
  }

  List<List<WorkSlot>> filterWorkSlotsForCurrentWeek(
      List<List<WorkSlot>> workSlots) {
    final now = DateTime.now();
    final weekStart =
        now.subtract(Duration(days: now.weekday - 1)); // Понедельник
    final weekEnd = weekStart.add(const Duration(
        days: 6, hours: 23, minutes: 59, seconds: 59)); // Воскресенье

    return workSlots.map((slots) {
      return slots.where((slot) {
        final slotDate = slot.startTime;
        return slotDate.isAfter(weekStart) && slotDate.isBefore(weekEnd);
      }).toList();
    }).toList();
  }

  static List<Events> _generateEventsForDay(
      DateTime day, List<List<WorkSlot>> workSlots) {
    List<Events> events = [];

    for (int i = 0; i < workSlots.length; i++) {
      final slots = workSlots[i];

      // Фильтруем только те слоты, которые относятся к текущему дню
      final daySlots = slots.where((slot) {
        final slotDate = slot.startTime;
        return slotDate.year == day.year &&
            slotDate.month == day.month &&
            slotDate.day == day.day; // Добавлена проверка на день
      }).toList();

      if (daySlots.isNotEmpty) {
        if (i == 0) {
          events.add(
            Events(
              event: daySlots.length,
              fillColor: AppColors.greenLighterBackgroundColor,
              textColor: AppColors.greenTextColor,
            ),
          );
        } else if (i == 1) {
          events.add(
            Events(
              event: daySlots.length,
              fillColor: AppColors.purpleLighterBackgroundColor,
              textColor: AppColors.purpleBrighterBackgroundColor,
            ),
          );
        }
      }
    }

    return events;
  }
}
