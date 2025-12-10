import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

import 'text.dart';

class SpecialistWorkDaysWidget extends StatelessWidget {
  const SpecialistWorkDaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(
        height: 1,
      ),
      12.h,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SpecialistTextWidget(
              text: t.consultation.specialistsConsultWorkDays.title,
              isTitle: true,
            ),
            SpecialistTextWidget(
              text: t.consultation.specialistsConsultWorkDays.subtitle,
              isTitle: false,
            ),
            const WeekContainer()
          ],
        ),
      ),
    ]);
  }
}
