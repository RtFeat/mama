import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';

class ConsultationTime extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool isWithTimeBefore;
  const ConsultationTime({
    super.key,
    required this.startDate,
    required this.endDate,
    this.isWithTimeBefore = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    int getDifference() {
      return endDate.difference(startDate).inMinutes;
    }

    String formatDate(DateTime start, DateTime end) {
      final now = DateTime.now();
      final dateFormat = DateFormat('H:mm');

      final bool isToday = start.year == now.year &&
          start.month == now.month &&
          start.day == now.day;

      final String time =
          '${dateFormat.format(start)}–${dateFormat.format(end)}';

      final String text = isToday
          ? '${t.home.today} $time'
          : '${start.day} ${t.home.monthsData[start.month]} $time';

      if (isWithTimeBefore) {
        return text.replaceFirst(' ', ', ');
      } else {
        return text;
      }
    }

    final Widget content = AutoSizeText(
      formatDate(startDate, endDate),
      maxLines: 1,
      style: textTheme.titleMedium?.copyWith(
        color:
            isWithTimeBefore ? themeData.colorScheme.onPrimaryContainer : null,
        fontWeight: isWithTimeBefore ? FontWeight.w400 : null,
      ),
    );

    return isWithTimeBefore
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              content,
              10.w,
              AutoSizeText(
                t.consultation.after(n: getDifference()),
                maxLines: 1,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          )
        : SizedBox(
            height: 20,
            child: FittedBox(
              child: content,
            ),
          );
  }
}
