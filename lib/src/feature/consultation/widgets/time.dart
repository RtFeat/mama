import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';

class ConsultationTime extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ConsultationStatus? status;
  const ConsultationTime({
    super.key,
    this.status,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final bool isWithTimeBefore = status != null;

    int getDifference() {
      return endDate.difference(DateTime.now()).inMinutes;
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
          : '${start.day} ${t.home.monthsData.withNumbers[start.month - 1]} $time';

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
            children: switch (status) {
              null => [],
              ConsultationStatus.completed => [
                  content,
                  10.w,
                  const Icon(
                    Icons.done,
                    color: AppColors.greenTextColor,
                  ),
                  4.w,
                  Text(
                    t.consultation.completed,
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      color: AppColors.greenTextColor,
                    ),
                  ),
                ],
              ConsultationStatus.rejected => [
                  content,
                  10.w,
                  const Icon(
                    Icons.done,
                    color: AppColors.redColor,
                  ),
                  4.w,
                  Text(
                    t.consultation.canceled,
                    style: textTheme.titleSmall?.copyWith(
                      fontSize: 14,
                      color: AppColors.redColor,
                    ),
                  ),
                ],
              ConsultationStatus.pending => [
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
            })
        : SizedBox(
            height: 20,
            child: FittedBox(
              child: content,
            ),
          );
  }
}
