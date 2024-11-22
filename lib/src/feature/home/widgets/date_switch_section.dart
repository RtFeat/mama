import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama/src/data.dart';

class DateSwitchSection extends StatelessWidget {
  final VoidCallback leftButtonOnPressed;
  final VoidCallback rightButtonOnPressed;
  final VoidCallback calendarButtonOnPressed;

  final CalendarStore store;

  const DateSwitchSection({
    super.key,
    required this.store,
    required this.leftButtonOnPressed,
    required this.rightButtonOnPressed,
    required this.calendarButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Observer(builder: (context) {
      final bool isToday = store.selectedDate.day == DateTime.now().day;
      final bool isTomorrow = store.selectedDate.day ==
          DateTime.now().add(const Duration(days: 1)).day;
      final bool isYesterday = store.selectedDate.day ==
          DateTime.now().subtract(const Duration(days: 1)).day;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// #switch
          Row(
            children: [
              /// #left button
              IconButton(
                onPressed: leftButtonOnPressed,
                icon: SvgPicture.asset(
                  Assets.icons.icArrowLeftFilled,
                  color: AppColors.primaryColor,
                ),
              ),

              /// #number date, word date
              Column(
                children: [
                  /// #number date
                  Text(
                    '${store.selectedDate.day} ${t.home.monthsData[store.selectedDate.month - 1]}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  /// #word date
                  if (isToday || isTomorrow || isYesterday)
                    Text(
                      isToday
                          ? t.home.today
                          : isTomorrow
                              ? t.home.tomorrow
                              : isYesterday
                                  ? t.home.yesterday
                                  : '',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyBrighterColor,
                      ),
                    ),
                ],
              ),

              /// #right button
              IconButton(
                onPressed: rightButtonOnPressed,
                icon: SvgPicture.asset(
                  Assets.icons.icArrowRightFilled,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),

          Row(
            children: [
              if (!isToday)
                GestureDetector(
                  onTap: () {
                    store.selectedDate = DateTime.now();
                  },
                  child: SizedBox(
                    width: 80,
                    height: 48,
                    child: Material(
                      color: AppColors.purpleLighterBackgroundColor,
                      borderRadius: 16.r,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: AutoSizeText(
                            t.home.backToToday,
                            minFontSize: 6,
                            maxLines: 2,
                            style: textTheme.titleLarge?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              10.w,

              /// #calendar button
              Material(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: AppColors.purpleLighterBackgroundColor,
                child: InkWell(
                  onTap: calendarButtonOnPressed,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SvgPicture.asset(
                        Assets.icons.icCalendarBadgeClockFilled,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
