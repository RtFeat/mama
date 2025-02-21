import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'text.dart';

class SpecialistWorkTimeWidget extends StatelessWidget {
  const SpecialistWorkTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final ScheduleViewStore store = context.watch();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Observer(builder: (context) {
          return Column(children: [
            SpecialistTextWidget(
              text: t.consultation.specialistsConsultWorkTime.title,
              isTitle: true,
            ),
            SpecialistTextWidget(
              text: t.consultation.specialistsConsultWorkTime.subtitle,
              isTitle: false,
            ),
            8.h,
            ...store.workSlots.mapIndexed((i, e) {
              return TimeContainer(index: i, time: e);
            }),
            10.h,
            CustomButton(
              borderRadius: 32,
              type: CustomButtonType.filled,
              backgroundColor: Colors.white,
              textStyle:
                  textTheme.bodyMedium?.copyWith(color: AppColors.primaryColor),
              title: "Добавить рабочее время",
              // icon: IconModel(icon: Icons.add),
              icon: AppIcons.plus,
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                ).then((v) {
                  if (v != null) {
                    final DateTime start =
                        DateTime(0, 1, 1, v.hour, v.minute).toUtc();
                    // final start =
                    //     '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')}';

                    if (context.mounted) {
                      showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 10, minute: 0))
                          .then((v) {
                        if (v != null) {
                          final DateTime end =
                              DateTime(0, 1, 1, v.hour, v.minute).toUtc();
                          // final end =
                          //     '${v.hour.toString().padLeft(2, '0')}:${v.minute.toString().padLeft(2, '0')}';

                          store.updateWorkSlots(start.timeRange(end));
                        }
                      });
                    }
                  }
                });
              },
            ),
            10.h,
          ]);
        }));
  }
}
