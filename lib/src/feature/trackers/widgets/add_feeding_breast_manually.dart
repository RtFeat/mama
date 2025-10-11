import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
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
        DateFormat('HH:mm').format(addFeeding.timerEndTime ?? DateTime.now());
    return ReactiveForm(
        formGroup: formGroup,
        child: BodyAddManuallySleepCryFeeding(
          stopIfStarted: () {},
          timerManualStart: addFeeding.timerStartTime,
          timerManualEnd: addFeeding.timerEndTime,
          formControlNameEnd: 'feedingBreastEnd',
          formControlNameStart: 'feedingBreastStart',
          onStartTimeChanged: (v) {
            final value = formGroup.control('feedingBreastStart').value;
            if (value != null) {
              addFeeding.setTimeStartManually(value);
            }
          },
          onEndTimeChanged: (v) {
            final value = formGroup.control('feedingBreastEnd').value;
            if (value != null) {
              addFeeding.setTimeEndManually(value);
            }
          },
          isTimerStart: addFeeding.isRightSideStart == true
              ? true
              : addFeeding.isLeftSideStart == true
                  ? true
                  : false,
          onTapConfirm: () async {
            // Если конец не выбран, зафиксируем текущий момент
            addFeeding.timerEndTime ??= DateTime.now();
            try {
              await addFeeding.addFeeding();
              // После успешного сохранения полностью сбрасываем состояние и останавливаем таймеры
              addFeeding.resetWithoutSaving();
              if (context.mounted) context.pop();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Не удалось сохранить запись, попробуйте позже')),
                );
              }
            }
          },
          titleIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.title,
          textIfEditNotComplete: t.feeding.ifEditNotCompleteFeed.text,
          bodyWidget: const ManuallyInputContainer(),
          needIfEditNotCompleteMessage: true,
        ));
    // });
  }
}
