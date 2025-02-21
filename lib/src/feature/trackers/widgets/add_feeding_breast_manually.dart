import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddFeedingBreastManually extends StatefulWidget {
  const AddFeedingBreastManually({super.key});

  @override
  State<AddFeedingBreastManually> createState() =>
      _AddFeedingBreastManuallyState();
}

class _AddFeedingBreastManuallyState extends State<AddFeedingBreastManually> {
  late FormGroup formGroup;

  @override
  void initState() {
    formGroup = FormGroup({
      'feedingBreastStart': FormControl(),
      'feedingBreastEnd': FormControl(),
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
    final AddFeeding addFeeding = context.watch<AddFeeding>();
    formGroup.control('feedingBreastStart').value =
        DateFormat('HH:mm').format(addFeeding.timerStartTime);
    formGroup.control('feedingBreastEnd').value =
        DateFormat('HH:mm').format(addFeeding.timerEndTime);
    return ReactiveForm(
        formGroup: formGroup,
        child: BodyAddManuallySleepCryFeeding(
          timerManualStart: addFeeding.timerStartTime,
          timerManualEnd: addFeeding.timerEndTime,
          formControlNameEnd: 'feedingBreastEnd',
          formControlNameStart: 'feedingBreastStart',
          onStartTimeChanged: () => addFeeding.setTimeStartManually(
              formGroup.control('feedingBreastStart').value),
          onEndTimeChanged: () => addFeeding
              .setTimeEndManually(formGroup.control('feedingBreastEnd').value),
          isTimerStart: addFeeding.isRightSideStart == true
              ? true
              : addFeeding.isLeftSideStart == true
                  ? true
                  : false,
          onTapConfirm: () {},
          titleIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.title,
          textIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.text,
          bodyWidget: const ManuallyInputContainer(),
          needIfEditNotCompleteMessage: true,
        ));
    // });
  }
}
