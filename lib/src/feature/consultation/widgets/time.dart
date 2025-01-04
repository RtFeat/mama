import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

    int getDifference() {
      final now = DateTime.now(); // Текущее локальное время
      final localStartDate = startDate.toLocal(); // Переводим в локальное время
      // Возвращаем разницу (включая отрицательные значения)
      return localStartDate.difference(now).inMinutes;
    }

    final bool isWithTimeBefore = status != null;

    return Observer(builder: (context) {
      return isWithTimeBefore
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: switch (status) {
                null => [],
                ConsultationStatus.completed => [
                    _Content(
                        startDate: startDate, endDate: endDate, status: status),
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
                    _Content(
                        startDate: startDate, endDate: endDate, status: status),
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
                    _Content(
                        startDate: startDate, endDate: endDate, status: status),
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
                child: _Content(
                    startDate: startDate, endDate: endDate, status: status),
              ),
            );
    });
  }
}

class _Content extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ConsultationStatus? status;
  const _Content({
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final bool isWithTimeBefore = status != null;
    // String formatTime() {
    //   final dateFormat = DateFormat('H:mm');

    //   final String time =
    //       '${dateFormat.format(startDate)}–${dateFormat.format(endDate)}';
    //   return time;
    // }

    String formatDate() {
      final now = DateTime.now();

      final bool isToday = startDate.year == now.year &&
          startDate.month == now.month &&
          startDate.day == now.day;

      final String text = isToday
          ? '${t.home.today} ${startDate.timeRange(endDate)}'
          : '${startDate.day} ${t.home.monthsData.withNumbers[startDate.month - 1]} ${startDate.timeRange(endDate)}';

      if (isWithTimeBefore) {
        return text.replaceFirst(' ', ', ');
      } else {
        return text;
      }
    }

    return Observer(builder: (_) {
      return AutoSizeText(
        formatDate(),
        maxLines: 1,
        style: textTheme.titleMedium?.copyWith(
          color: isWithTimeBefore
              ? themeData.colorScheme.onPrimaryContainer
              : null,
          fontWeight: isWithTimeBefore ? FontWeight.w400 : null,
        ),
      );
    });
  }
}
