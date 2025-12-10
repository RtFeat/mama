import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

import 'calendar/slots.dart';
import 'calendar/table.dart';

class DateSwitchSection extends StatelessWidget {
  final Function(DateTime value) leftButtonOnPressed;
  final Function(DateTime value) rightButtonOnPressed;
  final Function(DateTime value) calendarButtonOnPressed;

  final VoidCallback? backToTodayOnPressed;

  final bool isOnlyCalendar;

  const DateSwitchSection({
    super.key,
    required this.leftButtonOnPressed,
    required this.rightButtonOnPressed,
    required this.calendarButtonOnPressed,
    this.backToTodayOnPressed,
    this.isOnlyCalendar = false,
  });

  @override
  Widget build(BuildContext context) {
    final CalendarStore store = context.watch();

    final GlobalKey<MonthViewState> monthViewKey = GlobalKey<MonthViewState>();

    return Observer(builder: (context) {
      return store.isCalendar || isOnlyCalendar
          ? Column(
              children: [
                _Header(
                  isOnlyCalendar: isOnlyCalendar,
                  leftButtonOnPressed: (v) {
                    leftButtonOnPressed(v);
                    monthViewKey.currentState?.previousPage();
                  },
                  rightButtonOnPressed: (v) {
                    rightButtonOnPressed(v);
                    monthViewKey.currentState?.nextPage();
                  },
                  calendarButtonOnPressed: calendarButtonOnPressed,
                  backToTodayOnPressed: () {
                    monthViewKey.currentState!.animateToMonth(DateTime.now());
                    if (backToTodayOnPressed != null) {
                      backToTodayOnPressed!();
                    }
                  },
                ),
                CustomTableWidget(
                  store: context.watch(),
                  isOnlyCalendar: isOnlyCalendar,
                  doctorStore: context.watch(),
                  monthViewKey: monthViewKey,
                ),
              ],
            )
          : Column(
              children: [
                _Header(
                  leftButtonOnPressed: leftButtonOnPressed,
                  rightButtonOnPressed: rightButtonOnPressed,
                  calendarButtonOnPressed: calendarButtonOnPressed,
                  backToTodayOnPressed: backToTodayOnPressed,
                ),
                8.h,
                const SlotsWidget(),
              ],
            );
    });
  }
}

class _Header extends StatelessWidget {
  final Function(DateTime value) leftButtonOnPressed;
  final Function(DateTime value) rightButtonOnPressed;
  final Function(DateTime value) calendarButtonOnPressed;

  final VoidCallback? backToTodayOnPressed;
  final bool isOnlyCalendar;

  const _Header({
    required this.leftButtonOnPressed,
    required this.rightButtonOnPressed,
    required this.calendarButtonOnPressed,
    this.backToTodayOnPressed,
    this.isOnlyCalendar = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final CalendarStore store = context.watch();

    final DoctorStore doctorStore = context.watch();

    return Observer(builder: (context) {
      final DateTime now = DateTime.now();
      final bool isToday = store.selectedDate.day == now.day;
      final bool isTomorrow =
          store.selectedDate.day == now.add(const Duration(days: 1)).day;
      final bool isYesterday =
          store.selectedDate.day == now.subtract(const Duration(days: 1)).day;

      final String month =
          t.home.monthsData.title[store.selectedDate.month - 1];
      final String monthWithNumber =
          t.home.monthsData.withNumbers[store.selectedDate.month - 1];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// #switch
          Row(
            children: [
              /// #left button
              IconButton(
                onPressed: () {
                  store.setSelectedDate(
                    store.isCalendar || isOnlyCalendar
                        ? store.selectedDate
                            .copyWith(month: store.selectedDate.month - 1)
                        : store.selectedDate.subtract(
                            const Duration(days: 1),
                          ),
                  );
                  doctorStore.setSelectedDay(store.selectedDate.weekday);
                  leftButtonOnPressed(store.selectedDate);
                },
                // icon: SvgPicture.asset(
                //   Assets.icons.icArrowLeftFilled,
                //   color: AppColors.primaryColor,
                // ),
                icon: const Icon(
                  AppIcons.chevronBackward,
                  color: AppColors.primaryColor,
                ),
              ),

              /// #number date, word date
              Column(
                children: [
                  if (store.isCalendar || isOnlyCalendar)
                    Text(
                      '$month${store.selectedDate.year != now.year ? ' ${store.selectedDate.year}' : ''}',
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  if (!store.isCalendar && !isOnlyCalendar) ...[
                    Text(
                      '${store.selectedDate.day} $monthWithNumber',
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
                  ]
                ],
              ),

              /// #right button
              IconButton(
                onPressed: () {
                  store.setSelectedDate(
                    store.isCalendar || isOnlyCalendar
                        ? store.selectedDate
                            .copyWith(month: store.selectedDate.month + 1)
                        : store.selectedDate.add(
                            const Duration(days: 1),
                          ),
                  );
                  doctorStore.setSelectedDay(store.selectedDate.weekday);
                  rightButtonOnPressed(store.selectedDate);
                },
                // icon: SvgPicture.asset(
                //   Assets.icons.icArrowRightFilled,
                //   color: AppColors.primaryColor,
                // ),
                icon: const Icon(
                  AppIcons.chevronForward,
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
                    doctorStore.setSelectedDay(store.selectedDate.weekday);
                    if (backToTodayOnPressed != null) backToTodayOnPressed!();
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
              if (!isOnlyCalendar)
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: AppColors.purpleLighterBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      store.toggleIsCalendar();
                      calendarButtonOnPressed(store.selectedDate);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        AppIcons.calendar,
                        color: AppColors.primaryColor,
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
