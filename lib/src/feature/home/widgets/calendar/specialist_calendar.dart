import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'slots.dart';
import 'table.dart';

class SpecialistCalendarWidget extends StatelessWidget {
  const SpecialistCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorStore doctorStore = context.watch();

    return Provider(
      create: (context) => CalendarStore(),
      builder: (context, child) {
        final CalendarStore calendarStore = context.watch();

        return Observer(builder: (_) {
          final value = calendarStore.selectedDate;

          return CustomBackground(
            padding: 16,
            height: null,
            child: Column(
              children: [
                /// #switch section
                DateSwitchSection(
                  store: calendarStore,
                  leftButtonOnPressed: () {
                    calendarStore.setSelectedDate(
                      calendarStore.selectedDate.subtract(
                        const Duration(days: 1),
                      ),
                    );
                    doctorStore.data?.doctor?.workTime?.setSelectedTime(value);
                  },
                  rightButtonOnPressed: () {
                    calendarStore.setSelectedDate(
                      calendarStore.selectedDate.add(
                        const Duration(days: 1),
                      ),
                    );
                    doctorStore.data?.doctor?.workTime?.setSelectedTime(value);
                  },
                  calendarButtonOnPressed: () {
                    calendarStore.toggleIsCalendar();
                  },
                ),
                const SizedBox(height: 8),

                calendarStore.isCalendar ? CustomTableWidget() : SlotsWidget()
              ],
            ),
          );
        });
      },
    );
  }
}
