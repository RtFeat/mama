import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'duration.dart';
import 'title.dart';
import 'work_days.dart';
import 'work_time.dart';

class SpecialistScheduleWidget extends StatelessWidget {
  const SpecialistScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleViewStore store = context.watch();

    return SpecialistConsultingContainer(
      child: Observer(builder: (context) {
        return Column(
          children: [
            8.h,
            const SpecialistScheduleTitleWidget(),
            if (!store.isCollapsed) ...[
              8.h,
              const SpecialistWorkDaysWidget(),
              8.h,
              const Divider(),
              8.h,
              const SpecialistWorkTimeWidget(),
              8.h,
              const Divider(),
              8.h,
              const SpecialistDurationWidget(),
            ]
          ],
        );
      }),
    );
  }
}
