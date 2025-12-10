import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/edit_time_row.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/feeding_edit_time_row.dart';
import 'package:mama/src/core/core.dart';

class FeedingEditingTrackWidget extends StatelessWidget {
  final String title;
  final String noteTitle;
  final String noteText;
  final VoidCallback onPressNote;
  final VoidCallback onPressSubmit;
  final VoidCallback onPressCancel;
  final VoidCallback onPressManually;
  final DateTime timerStart;
  final DateTime? timerEnd;
  final bool isTimerStarted;
  final String formControlNameStart;
  final String formControlNameEnd;
  final AddFeeding addFeeding;

  const FeedingEditingTrackWidget({
    super.key,
    required this.title,
    required this.noteTitle,
    required this.noteText,
    required this.onPressNote,
    required this.onPressSubmit,
    required this.onPressCancel,
    required this.onPressManually,
    required this.timerStart,
    required this.timerEnd,
    required this.isTimerStarted,
    required this.formControlNameStart,
    required this.formControlNameEnd,
    required this.addFeeding,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    
    return Observer(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              
              // Time information cards - exactly like Sleep
              Observer(
                builder: (context) {
                  try {
                    return FeedingEditTimeRow(
                      onTap: () {},
                      timerStart: addFeeding.timerStartTime,
                      timerEnd: addFeeding.timerEndTime,
                      isTimerStarted: addFeeding.isLeftSideStart || addFeeding.isRightSideStart,
                      formControlNameStart: formControlNameStart,
                      formControlNameEnd: formControlNameEnd,
                      onStartTimeChanged: (v) {
                        if (v != null) {
                          addFeeding.setTimeStartManually(v);
                        }
                      },
                      onEndTimeChanged: (v) {
                        if (v != null) {
                          addFeeding.setTimeEndManually(v);
                        }
                      },
                      addFeeding: addFeeding,
                    );
                  } catch (e) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Timer data not available',
                        style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Action buttons - exactly like Sleep
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      type: CustomButtonType.outline,
                      maxLines: 1,
                      onTap: () {
                        onPressNote();
                      },
                      icon: AppIcons.pencil,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                      textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      title: t.trackers.currentEditTrackButtonNote,
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      backgroundColor: AppColors.greenLighterBackgroundColor,
                      onTap: () {
                        onPressSubmit();
                      },
                      title: t.trackers.currentEditTrackButtonSubmit,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      textStyle: textTheme.titleMedium
                          ?.copyWith(color: AppColors.greenTextColor),
                    ),
                  ),
                ],
              ),
              10.h,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      type: CustomButtonType.filled,
                      backgroundColor: AppColors.redLighterBackgroundColor,
                      onTap: () {
                        onPressCancel();
                      },
                      icon: AppIcons.xmark,
                      iconColor: AppColors.redColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      textStyle: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.redColor),
                      title: t.trackers.currentEditTrackButtonCancel,
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      backgroundColor: AppColors.purpleLighterBackgroundColor,
                      onTap: () {
                        onPressManually();
                      },
                      title: t.trackers.currentEditTrackButtonManually,
                      icon: AppIcons.calendar,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      textStyle: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              20.h,
              Text(
                noteTitle,
                style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: AppColors.greyBrighterColor),
              ),
              5.h,
              Text(noteText,
                  textAlign: TextAlign.center,
                  style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyBrighterColor)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSideTimer(
    BuildContext context,
    String side,
    String currentTime,
    String totalTime,
    bool isRunning,
  ) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRunning ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRunning ? Colors.blue[200]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isRunning ? Colors.blue : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$side Side',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Current: $currentTime',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Total: $totalTime',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
