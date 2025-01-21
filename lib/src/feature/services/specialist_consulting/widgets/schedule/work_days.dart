import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SpecialistTextWidget(
              text: "Рабочие дни",
              isTitle: true,
            ),
            SpecialistTextWidget(
              text:
                  "Установите рабочие дни в неделе. Конкретный день можно переназначить в календаре",
              isTitle: false,
            ),
            WeekContainer()
          ],
        ),
      ),
    ]);
  }
}
