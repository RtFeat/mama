import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class SpecialistConsultingScreen extends StatelessWidget {
  const SpecialistConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Расписание',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.trackerColor2
          ),
        ),
      ),
      body: ListView(
        children: const [
           BasicMeshWidget(),
           CalendarWidget(),
           SaveButton()
        ],
      ),
    );
  }
}
