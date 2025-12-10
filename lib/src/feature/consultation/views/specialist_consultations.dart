import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/home/widgets/calendar/calendar.dart';

class SpecialistConsultationsView extends StatelessWidget {
  const SpecialistConsultationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: t.consultation.title,
        ),
        body: const SpecialistCalendarWidget());
  }
}
