import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class EditTimeRow extends StatelessWidget {
  final String formControlNameStart;
  final String formControlNameEnd;
  final DateTime timerStart;
  final bool isTimerStarted;
  final DateTime? timerEnd;
  final VoidCallback? onStartTimeChanged;
  final VoidCallback? onEndTimeChanged;
  const EditTimeRow({
    super.key,
    required this.timerStart,
    this.timerEnd,
    this.isTimerStarted = false,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    required this.formControlNameStart,
    required this.formControlNameEnd,
  });

  @override
  Widget build(BuildContext context) {
    String timeStart = DateFormat('HH:mm').format(timerStart);
    var infinity = String.fromCharCodes(Runes('\u221E'));
    int minutes;
    int seconds;
    String timeTotal;
    String timeEnd = timerEnd == null || isTimerStarted
        ? infinity
        : DateFormat('HH:mm').format(timerEnd!);
    if (timerEnd != null && !isTimerStarted) {
      Duration difference = timerEnd!.difference(timerStart);
      minutes = difference.inMinutes % 60;
      seconds = difference.inSeconds % 60;
      timeTotal = '$minutes${t.trackers.min} $seconds${t.trackers.sec}';
    } else {
      timeTotal = infinity;
    }

    return Row(
      children: [
        Expanded(
            child: DetailContainer(
          title: t.feeding.start,
          text: timeStart,
          detail: t.feeding.change,
          filled: true,
          isEdited: true,
          formControlName: formControlNameStart,
          onChanged: () {
            onStartTimeChanged!();
          },
        )),
        10.w,
        Expanded(
            child: DetailContainer(
          title: t.feeding.end,
          text: timeEnd,
          detail: isTimerStarted
              ? t.trackers.currentEditTrackButtonTimerStart
              : t.feeding.change,
          filled: true,
          isEdited: isTimerStarted ? false : true,
          formControlName: formControlNameEnd,
          onChanged: () {
            onEndTimeChanged!();
          },
        )),
        10.w,
        Expanded(
            child: DetailContainer(
          title: t.feeding.total,
          text: timeTotal,
          detail: '',
          filled: false,
          isEdited: false,
        )),
      ],
    );
  }
}
