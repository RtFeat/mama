import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CalendarVaccines extends StatelessWidget {
  const CalendarVaccines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: t.trackers.vaccines.calendarViewAppBar,
        appBarColor: AppColors.e8ddf9,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 17, color: AppColors.blueDark),
      ),
      backgroundColor: AppColors.primaryColorBright,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CalendarVaccineContainer(
              nameCalendar: t.trackers.vaccines.calendarViewRecomended,
              onTapPDF: () {
                //TODO добавить загрузку пдф
              },
            ),
            16.h,
            CalendarVaccineContainer(
              nameCalendar: t.trackers.vaccines.calendarViewIdeal,
              onTapPDF: () {
                //TODO добавить загрузку пдф
              },
            ),
          ],
        ),
      ),
    );
  }
}
