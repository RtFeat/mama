import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class BodyAddManuallySleepCryFeeding extends StatefulWidget {
  final String? formControlNameStart;
  final String? formControlNameEnd;
  final bool needIfEditNotCompleteMessage;
  final String? titleIfEditNotComplete;
  final String? textIfEditNotComplete;
  final Widget bodyWidget;

  final DateTime timerManualStart;
  final bool isTimerStart;
  final DateTime? timerManualEnd;
  final Function(String? value)? onStartTimeChanged;
  final Function(String? value)? onEndTimeChanged;
  final VoidCallback? onTapNotes;
  final VoidCallback? onTapConfirm;
  final Function() stopIfStarted;

  const BodyAddManuallySleepCryFeeding({
    super.key,
    this.formControlNameStart,
    this.formControlNameEnd,
    required this.timerManualStart,
    this.timerManualEnd,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    this.onTapNotes,
    required this.onTapConfirm,
    required this.isTimerStart,
    this.titleIfEditNotComplete,
    this.textIfEditNotComplete,
    required this.bodyWidget,
    required this.stopIfStarted,
    required this.needIfEditNotCompleteMessage,
  });

  @override
  State<BodyAddManuallySleepCryFeeding> createState() =>
      _BodyAddManuallySleepCryFeedingState();
}

class _BodyAddManuallySleepCryFeedingState
    extends State<BodyAddManuallySleepCryFeeding> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    DateTime timerStart = widget.timerManualStart;
    DateTime? timerEnd = widget.timerManualEnd;

    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        title: t.feeding.addManually,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.trackerColor,
              fontSize: 17,
              letterSpacing: -0.5,
            ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: widget.needIfEditNotCompleteMessage && widget.isTimerStart
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          widget.titleIfEditNotComplete!,
                          style: textTheme.labelMedium?.copyWith(
                              fontSize: 14, color: AppColors.greyBrighterColor),
                        ),
                        8.h,
                        Text(
                          textAlign: TextAlign.center,
                          widget.textIfEditNotComplete!,
                          style: textTheme.labelMedium?.copyWith(
                              fontSize: 14, color: AppColors.greyBrighterColor),
                        ),
                        16.h,
                        CustomButton(
                          isSmall: false,
                          type: CustomButtonType.outline,
                          onTap: () {
                            context.pop();
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          textStyle: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          title: t.trackers
                              .infoManuallyContainerButtonBackAndContinue,
                        ),
                        16.h,
                      ],
                    )
                  : null,
            ),
            widget.bodyWidget,
            30.h,
            EditTimeRow(
              onTap: () {
                if (widget.isTimerStart) {
                  widget.stopIfStarted();
                }
              },
              timerStart: timerStart,
              timerEnd: timerEnd,
              isTimerStarted: widget.isTimerStart,
              onStartTimeChanged: (v) {
                widget.onStartTimeChanged!(v);
                setState(() {});
              },
              onEndTimeChanged: (v) {
                widget.onEndTimeChanged!(v);
                setState(() {});
              },
              formControlNameStart: widget.formControlNameStart!,
              formControlNameEnd: widget.formControlNameEnd!,
            ),
            32.h,
            CustomButton(
              height: 48,
              width: double.infinity,
              type: CustomButtonType.outline,
              icon: AppIcons.pencil,
              iconColor: AppColors.primaryColor,
              title: t.feeding.note,
              onTap: () => widget.onTapNotes!(),
              iconSize: 28,
            ),
            8.h,
            CustomButton(
              backgroundColor: AppColors.greenLighterBackgroundColor,
              height: 48,
              width: double.infinity,
              title: t.feeding.confirm,
              onTap: widget.onTapConfirm,
            ),
            35.h,
          ],
        ),
      ),
    );
  }
}
