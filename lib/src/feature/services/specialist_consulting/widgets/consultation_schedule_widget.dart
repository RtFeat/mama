import 'package:flutter/material.dart';
import 'package:mama/src/core/constant/colors.dart';

class ConsultationScheduleWidget extends StatelessWidget {
  final String startTime;
  final String entTime;
  final Map<String, String> scheduleTimes;

  const ConsultationScheduleWidget(
      {super.key,
      required this.startTime,
      required this.entTime,
      required this.scheduleTimes});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Column(
      children: [
        Row(
          children: [
            Text(
              startTime,
              style: textTheme.labelLarge?.copyWith(color: Colors.black),
            ),
            const Spacer(),
            Text(entTime,
                style: textTheme.labelLarge?.copyWith(color: Colors.black))
          ],
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.greenLighterBackgroundColor),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final values = scheduleTimes.values.toList();
                  final keys = scheduleTimes.keys.toList();
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                    child: Column(
                      children: [
                        Text(
                          keys[index],
                          style: textTheme.labelSmall
                              ?.copyWith(color: AppColors.greenTextColor),
                        ),
                        Text(
                          values[index],
                          style: textTheme.labelSmall
                              ?.copyWith(color: AppColors.greenTextColor),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const VerticalDivider(
                    color: Colors.white,
                    width: 2,
                  );
                },
                itemCount: scheduleTimes.length),
          ),
        )
      ],
    );
  }
}
