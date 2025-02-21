import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddSleepingScreenManually extends StatefulWidget {
  const AddSleepingScreenManually({super.key});

  @override
  State<AddSleepingScreenManually> createState() =>
      _AddSleepingScreenManuallyState();
}

class _AddSleepingScreenManuallyState extends State<AddSleepingScreenManually> {
  late FormGroup formGroup;

  @override
  void initState() {
    formGroup = FormGroup({
      'sleepStart': FormControl(),
      'sleepEnd': FormControl(),
    });
    super.initState();
  }

  @override
  void dispose() {
    formGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AddSleeping addSleeping = context.watch<AddSleeping>();
    formGroup.control('sleepStart').value =
        DateFormat('HH:mm').format(addSleeping.manualStartTime);
    formGroup.control('sleepEnd').value =
        DateFormat('HH:mm').format(addSleeping.manualEndTime);
    return ReactiveForm(
        formGroup: formGroup,
        child: BodyAddManuallySleepCryFeeding(
          needIfEditNotCompleteMessage: true,
          timerManualStart: addSleeping.manualStartTime,
          timerManualEnd: addSleeping.manualEndTime,
          formControlNameEnd: 'sleepEnd',
          formControlNameStart: 'sleepStart',
          onStartTimeChanged: () => addSleeping
              .setTimeStartManually(formGroup.control('sleepStart').value),
          onEndTimeChanged: () => addSleeping
              .setTimeEndManually(formGroup.control('sleepEnd').value),
          isTimerStart: addSleeping.timerSleepStart,
          onTapConfirm: () {},
          titleIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.title,
          textIfEditNotComplete: t.trackers.ifEditNotCompleteSleep.text,
          bodyWidget: BodyCommentSleep(
            titleAddNewManual: t.trackers.addNewManualSleep.title,
            textAddNewManual: t.trackers.addNewManualSleep.text,
          ),
        ));
    // });
  }
}

class BodyCommentSleep extends StatelessWidget {
  final String titleAddNewManual;
  final String textAddNewManual;
  const BodyCommentSleep(
      {super.key,
      required this.titleAddNewManual,
      required this.textAddNewManual});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyColor, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              titleAddNewManual,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20, color: AppColors.greyBrighterColor),
            ),
            10.h,
            Text(
              textAlign: TextAlign.center,
              textAddNewManual,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 14, color: AppColors.greyBrighterColor),
            ),
          ],
        ),
      ),
    );
  }
}
