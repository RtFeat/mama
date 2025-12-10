import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleViewStore store = context.watch();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: CustomButton(
        backgroundColor: AppColors.lightBlueBackgroundStatus,
        onTap: () {
          store.updateWorkTime(context);
        },
        title: t.profile.save,
      ),
    );
  }
}
