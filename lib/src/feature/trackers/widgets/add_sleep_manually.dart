import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
        child: BodyAddManuallySleepCry(
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
          titleAddNewManual: t.trackers.addNewManualSleep.title,
          textAddNewManual: t.trackers.addNewManualSleep.text,
        ));
    // });
  }
}
