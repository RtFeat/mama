import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class EditTimeRow extends StatelessWidget {
  final String formControlNameStart;
  final String formControlNameEnd;
  final DateTime timerStart;
  final bool isTimerStarted;
  final DateTime? timerEnd;
  final Function(String?)? onStartTimeChanged;
  final Function(String?)? onEndTimeChanged;

  final Function() onTap;

  const EditTimeRow({
    super.key,
    required this.timerStart,
    this.timerEnd,
    required this.onTap,
    this.isTimerStarted = false,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    required this.formControlNameStart,
    required this.formControlNameEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final SleepStore? store = context.watch();

      final DateTime start = store?.timerStartTime ?? timerStart;
      final DateTime? end = store?.timerEndTime ?? timerEnd;

      return Row(
        children: [
          Expanded(
              child: DetailContainer(
            onTap: onTap,
            title: t.feeding.start,
            text: start.formattedTime,
            detail: t.feeding.change,
            filled: true,
            isEdited: true,
            formControlName: formControlNameStart,
            onChanged: (v) {
              onStartTimeChanged!(v);
            },
          )),
          10.w,
          Expanded(
              child: DetailContainer(
            onTap: onTap,
            title: t.feeding.end,
            text: isTimerStarted ? '\u221E' : end?.formattedTime ?? '\u221E',
            detail: isTimerStarted
                ? t.trackers.currentEditTrackButtonTimerStart
                : t.feeding.change,
            filled: true,
            isEdited: isTimerStarted ? false : true,
            formControlName: formControlNameEnd,
            onChanged: (v) {
              onEndTimeChanged!(v);
            },
          )),
          10.w,
          Expanded(
              child: DetailContainer(
            onTap: onTap,
            title: t.feeding.total,
            text: start.getTotalTime(end),
            detail: '',
            filled: false,
            isEdited: false,
          )),
        ],
      );
    });
  }
}
