import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class WeekContainer extends StatelessWidget {
  const WeekContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScheduleViewStore store = context.watch();

    return ItemsLineWidget(
      height: 70,
      data: store.weeks,
      builder: (item, isFirst, isLast) {
        return _WeekBloc(
            week: item,
            borderRadius: isFirst
                ? const BorderRadius.horizontal(left: Radius.circular(24))
                : isLast
                    ? const BorderRadius.horizontal(right: Radius.circular(24))
                    : null);
      },
    );
  }
}

class _WeekBloc extends StatelessWidget {
  final BorderRadius? borderRadius;
  final WeekDay week;

  const _WeekBloc({this.borderRadius, required this.week});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return GestureDetector(
      onTap: () {
        week.setIsWork(!(week.isWork ?? true));
      },
      child: Observer(builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: (week.isWork ?? true) ? AppColors.primaryColor : null,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                Text(
                  week.title ?? '',
                  style: textTheme.bodyMedium?.copyWith(
                      color: (week.isWork ?? true)
                          ? Colors.white
                          : AppColors.primaryColor),
                ),
                if (week.isWork ?? true)
                  Expanded(
                      child: SvgPicture.asset(
                    Assets.icons.icCheck,
                  ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
