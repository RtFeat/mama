import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/timer_interface.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep.dart';

class EditTimeRow extends StatelessWidget {
  final String formControlNameStart;
  final String formControlNameEnd;
  final DateTime timerStart;
  final bool isTimerStarted;
  final DateTime? timerEnd;
  final Function(String?)? onStartTimeChanged;
  final Function(String?)? onEndTimeChanged;
  final CryStore? cryStore;
  final SleepStore? sleepStore;
  // Allow manual editing of End even when a timer is currently running
  final bool allowEditEndWhenTimerStarted;

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
    this.cryStore,
    this.sleepStore,
    this.allowEditEndWhenTimerStarted = false,
  });

  Future<DateTime?> _pickTime(BuildContext context, DateTime initial) async {
    final TimeOfDay init = TimeOfDay(hour: initial.hour, minute: initial.minute);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: init,
    );
    if (picked == null) return null;
    final DateTime now = DateTime.now();
    int hour24;
    // Convert to 24h explicitly to avoid AM/PM issues
    try {
      final int hop = picked.hourOfPeriod; // 0..11
      if (picked.period == DayPeriod.am) {
        hour24 = (hop == 12 || hop == 0) ? 0 : hop;
      } else {
        hour24 = (hop == 12 || hop == 0) ? 12 : hop + 12;
      }
    } catch (_) {
      // Fallback to picked.hour (may already be 0..23 depending on locale)
      hour24 = picked.hour;
    }
    return DateTime(now.year, now.month, now.day, hour24, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        // Используем актуальные значения из store для отображения
        // Prefer cry store values when provided (for Cry Add Manually), otherwise sleep store
        final DateTime start =
            (cryStore?.timerStartTime ?? sleepStore?.timerStartTime) ?? timerStart;
        final DateTime? end =
            (cryStore?.timerEndTime ?? sleepStore?.timerEndTime) ?? timerEnd;
        // Force reactive updates each second while running by observing currentTimerDisplay
        // even if we do not use it directly.
        final _tick = cryStore?.currentTimerDisplay ?? sleepStore?.currentTimerDisplay;

        // Prefer store-provided total, which correctly handles pause/resume and end.
        String totalTime;
        if (cryStore != null) {
          totalTime = cryStore!.totalDuration;
        } else if (sleepStore != null) {
          totalTime = sleepStore!.totalDuration;
        } else {
          // Fallback calculation if no store provided
          if (isTimerStarted) {
            final now = DateTime.now();
            final duration = now.difference(start);
            final hours = duration.inHours;
            final minutes = duration.inMinutes % 60;
            final seconds = duration.inSeconds % 60;
            if (hours > 0) {
              totalTime = '${hours}ч ${minutes}м ${seconds}с';
            } else {
              totalTime = '${minutes}м ${seconds}с';
            }
          } else if (end != null) {
            DateTime effectiveEnd = end;
            if (effectiveEnd.isBefore(start)) {
              effectiveEnd = effectiveEnd.add(const Duration(days: 1));
            }
            final duration = effectiveEnd.difference(start);
            final hours = duration.inHours;
            final minutes = duration.inMinutes % 60;
            final seconds = duration.inSeconds % 60;
            if (hours > 0) {
              totalTime = '${hours}ч ${minutes}м ${seconds}с';
            } else {
              totalTime = '${minutes}м ${seconds}с';
            }
          } else {
            totalTime = '0м 0с';
          }
        }

        return Row(
          children: [
            Expanded(
              child: DetailContainer(
                onTap: () async {
                  final DateTime? picked = await _pickTime(context, start);
                  if (picked != null) {
                    if (sleepStore != null) {
                      sleepStore!.updateStartTime(picked);
                    }
                    if (cryStore != null) {
                      cryStore!.updateStartTime(picked);
                    }
                    if (onStartTimeChanged != null) {
                      onStartTimeChanged!(picked.formattedTime);
                    }
                  }
                },
                title: t.feeding.start,
                text: start.formattedTime,
                detail: t.feeding.change,
                filled: true,
                isEdited: false,
                formControlName: formControlNameStart,
                onChanged: (v) {
                  onStartTimeChanged!(v);
                },
              ),
            ),
            10.w,
            Expanded(
              child: DetailContainer(
                onTap: () async {
                  if (isTimerStarted && !allowEditEndWhenTimerStarted) return; // блокируем только если не разрешено вручную
                  final DateTime base = end ?? DateTime.now();
                  final DateTime? picked = await _pickTime(context, base);
                  if (picked != null) {
                    if (sleepStore != null) {
                      sleepStore!.updateEndTime(picked);
                      // фикс: считаем, что end установлен вручную, не перезаписываем автообновлением
                      // через setPausedEndToNow, т.к. там проверка на null
                    }
                    if (cryStore != null) {
                      cryStore!.updateEndTime(picked);
                    }
                    if (onEndTimeChanged != null) {
                      onEndTimeChanged!(picked.formattedTime);
                    }
                  }
                },
                title: t.feeding.end,
                text: (!isTimerStarted || allowEditEndWhenTimerStarted)
                    ? (end?.formattedTime ?? '\u221E')
                    : '\u221E',
                detail: (!isTimerStarted || allowEditEndWhenTimerStarted)
                    ? t.feeding.change
                    : t.trackers.currentEditTrackButtonTimerStart,
                filled: true,
                isEdited: false,
                formControlName: formControlNameEnd,
                onChanged: (v) {
                  onEndTimeChanged!(v);
                },
              ),
            ),
            10.w,
            Expanded(
              child: DetailContainer(
                onTap: onTap,
                title: t.feeding.total,
                text: totalTime,
                detail: '',
                filled: false,
                isEdited: false,
              ),
            ),
          ],
        );
      },
    );
  }
}
