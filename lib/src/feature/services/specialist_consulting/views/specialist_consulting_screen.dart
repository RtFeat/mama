import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import '../widgets/save_button.dart';

class SpecialistConsultingScreen extends StatelessWidget {
  const SpecialistConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          t.consultation.schedule,
          style:
              textTheme.titleMedium?.copyWith(color: AppColors.trackerColor2),
        ),
      ),
      body: ListView(
        children: [
          const SpecialistScheduleWidget(),
          // CalendarWidget(),

          20.h,
          CustomBackground(
              padding: 16,
              height: null,
              child: DateSwitchSection(
                  isOnlyCalendar: true,
                  leftButtonOnPressed: (v) {},
                  rightButtonOnPressed: (v) {},
                  calendarButtonOnPressed: (v) {})),

          // CustomTableWidget(
          //   monthViewKey: GlobalKey<MonthViewState>(),
          //   doctorStore: context.watch(),
          // ),
          const SaveButton()
        ],
      ),
    );
  }
}
