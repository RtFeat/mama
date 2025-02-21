import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class TimeContainer extends StatelessWidget {
  final int index;
  final String time;

  const TimeContainer({super.key, required this.index, required this.time});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ScheduleViewStore store = context.watch();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.lightBlueBackgroundStatus,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Уменьшаем размер Row до минимального
            children: [
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Text(
                  time,
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall?.copyWith(color: Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  store.removeWorkSlots(index);
                },
                child: const Icon(AppIcons.xmark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
