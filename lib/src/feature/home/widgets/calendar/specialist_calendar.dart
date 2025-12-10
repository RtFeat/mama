import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SpecialistCalendarWidget extends StatelessWidget {
  const SpecialistCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorStore doctorStore = context.watch();

    return CustomBackground(
        padding: 16,
        height: null,
        child: DateSwitchSection(
          leftButtonOnPressed: (value) {
            doctorStore.data?.doctor?.workTime?.setSelectedTime(value);
          },
          rightButtonOnPressed: (value) {
            doctorStore.data?.doctor?.workTime?.setSelectedTime(value);
          },
          calendarButtonOnPressed: (value) {},
        ));
  }
}
