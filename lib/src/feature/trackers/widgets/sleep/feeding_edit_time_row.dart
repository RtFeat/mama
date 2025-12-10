import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/add_feeding.dart';
import 'package:mama/src/feature/trackers/widgets/detail_container.dart';

class FeedingEditTimeRow extends StatelessWidget {
  final String formControlNameStart;
  final String formControlNameEnd;
  final DateTime timerStart;
  final bool isTimerStarted;
  final DateTime? timerEnd;
  final Function(String?)? onStartTimeChanged;
  final Function(String?)? onEndTimeChanged;
  final AddFeeding addFeeding;

  final Function() onTap;

  const FeedingEditTimeRow({
    super.key,
    required this.timerStart,
    this.timerEnd,
    required this.onTap,
    this.isTimerStarted = false,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    required this.formControlNameStart,
    required this.formControlNameEnd,
    required this.addFeeding,
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
    try {
      final int hop = picked.hourOfPeriod;
      if (picked.period == DayPeriod.am) {
        hour24 = (hop == 12 || hop == 0) ? 0 : hop;
      } else {
        hour24 = (hop == 12 || hop == 0) ? 12 : hop + 12;
      }
    } catch (_) {
      hour24 = picked.hour;
    }
    return DateTime(now.year, now.month, now.day, hour24, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        // Read reactive values INSIDE Observer so MobX can track them
        final DateTime start = addFeeding.timerStartTime;
        final DateTime? end = addFeeding.timerEndTime;
        final bool timerRunning = addFeeding.isLeftSideStart || addFeeding.isRightSideStart;

        // Use store total when timers/pauses exist (prevents ticking on pause)
        final bool hasSideData =
            addFeeding.isLeftSideStart ||
            addFeeding.isRightSideStart ||
            addFeeding.leftTimerStartTime != null ||
            addFeeding.rightTimerStartTime != null ||
            addFeeding.leftPauseTime != null ||
            addFeeding.rightPauseTime != null;
        final bool manualOverride =
            (addFeeding.startTimeManuallySet || addFeeding.endTimeManuallySet) && !timerRunning;
        String totalTime;
        if (hasSideData && !manualOverride) {
          totalTime = addFeeding.combinedTotalDuration;
        } else {
          // Manual mode: compute from Start/End like in Sleep
          if (timerRunning) {
            final now = DateTime.now();
            final duration = now.difference(start);
            final hours = duration.inHours;
            final minutes = duration.inMinutes % 60;
            final seconds = duration.inSeconds % 60;
            if (hours > 0) {
              totalTime = '${hours}ч ${minutes}м ${seconds}с';
            } else if (minutes > 0) {
              totalTime = '${minutes}м ${seconds}с';
            } else {
              totalTime = '${seconds}с';
            }
          } else if (end != null) {
            DateTime effectiveEnd = end;
            if (effectiveEnd.isBefore(start)) {
              effectiveEnd = effectiveEnd.add(const Duration(days: 1));
            }
            final duration = effectiveEnd.difference(start).abs();
            final hours = duration.inHours;
            final minutes = duration.inMinutes % 60;
            final seconds = duration.inSeconds % 60;
            if (hours > 0) {
              totalTime = '${hours}ч ${minutes}м ${seconds}с';
            } else if (minutes > 0) {
              totalTime = '${minutes}м ${seconds}с';
            } else if (seconds > 0) {
              totalTime = '${seconds}с';
            } else {
              totalTime = '0м 0с';
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
                  final DateTime base = start;
                  final DateTime? picked = await _pickTime(context, base);
                  if (picked != null) {
                    addFeeding.setTimeStartManually(DateFormat('HH:mm').format(picked));
                    if (onStartTimeChanged != null) {
                      onStartTimeChanged!(DateFormat('HH:mm').format(picked));
                    }
                  }
                },
                title: t.feeding.start,
                text: DateFormat('HH:mm').format(start),
                detail: t.feeding.change,
                filled: true,
                isEdited: false,
                formControlName: formControlNameStart,
                onChanged: (v) {
                  if (onStartTimeChanged != null) onStartTimeChanged!(v);
                  if (v != null) {
                    addFeeding.setTimeStartManually(v);
                  }
                },
              ),
            ),
            10.w,
            Expanded(
              child: DetailContainer(
                onTap: () async {
                  if (isTimerStarted) return; // как в Sleep, нельзя менять конец во время таймера
                  final DateTime base = end ?? DateTime.now();
                  final DateTime? picked = await _pickTime(context, base);
                  if (picked != null) {
                    addFeeding.setTimerEndTime(picked);
                    if (onEndTimeChanged != null) {
                      onEndTimeChanged!(DateFormat('HH:mm').format(picked));
                    }
                  }
                },
                title: t.feeding.end,
                text: timerRunning
                    ? '\u221E'
                    : (end != null ? DateFormat('HH:mm').format(end) : '\u221E'),
                detail: t.feeding.change,
                filled: true,
                isEdited: false,
                formControlName: formControlNameEnd,
                onChanged: (v) {
                  if (onEndTimeChanged != null) onEndTimeChanged!(v);
                  if (v != null) {
                    addFeeding.setTimeEndManually(v);
                  }
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

  Widget _buildTimeCard(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    Color backgroundColor,
    {required VoidCallback onTap}
  ) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
