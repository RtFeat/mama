import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

import 'slots.dart';
import 'text.dart';

class SpecialistDurationWidget extends StatelessWidget {
  const SpecialistDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SpecialistTextWidget(
              text: 'Длительность консультации',
              isTitle: true,
            ),
            const SpecialistTextWidget(
              text:
                  'Задайте длительность консультации и ваши рабочие дни разобьются на слоты, '
                  'в которые смогут записаться ваши пациенты',
              isTitle: false,
            ),
            5.h,
            Row(
              children: [
                IconWidget(
                    model: IconModel(iconPath: Assets.icons.icGreenWarning)),
                8.w,
                const Expanded(
                  child: SpecialistTextWidget(
                    text:
                        'Консультации идут одна за одной. Добавьте себе время на перерыв',
                    isTitle: false,
                  ),
                ),
              ],
            ),
            10.h,
            const ConsultationTimeWidget(),
            const ScheduleSlotsWidget(),
            20.h
          ],
        ));
  }
}
