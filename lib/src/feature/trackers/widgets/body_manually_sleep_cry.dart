import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class BodyAddManuallySleepCryFeeding extends StatelessWidget {
  final String? formControlNameStart;
  final String? formControlNameEnd;
  final String titleIfEditNotComplete;
  final String textIfEditNotComplete;
  final Widget bodyWidget;

  final DateTime timerManualStart;
  final bool isTimerStart;
  final DateTime? timerManualEnd;
  final VoidCallback? onStartTimeChanged;
  final VoidCallback? onEndTimeChanged;
  final VoidCallback? onTapNotes;
  final VoidCallback onTapConfirm;
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
    required this.titleIfEditNotComplete,
    required this.textIfEditNotComplete,
    required this.bodyWidget,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    DateTime timerStart = timerManualStart;
    DateTime timerEnd = timerManualEnd!;

    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(t.feeding.addManually,
            style: textTheme.titleMedium
                ?.copyWith(color: const Color(0xFF163C63))),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              child: isTimerStart
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          titleIfEditNotComplete,
                          style: textTheme.labelMedium?.copyWith(
                              fontSize: 14, color: AppColors.greyBrighterColor),
                        ),
                        5.h,
                        Text(
                          textAlign: TextAlign.center,
                          textIfEditNotComplete,
                          style: textTheme.labelMedium?.copyWith(
                              fontSize: 14, color: AppColors.greyBrighterColor),
                        ),
                        10.h,
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
                        15.h,
                      ],
                    )
                  : null,
            ),
            bodyWidget,
            30.h,
            EditTimeRow(
              timerStart: timerStart,
              onStartTimeChanged: () {
                onStartTimeChanged!();
              },
              onEndTimeChanged: () {
                onEndTimeChanged!();
              },
              timerEnd: timerEnd,
              formControlNameStart: formControlNameStart!,
              formControlNameEnd: formControlNameEnd!,
            ),
            30.h,
            CustomButton(
              height: 48,
              width: double.infinity,
              type: CustomButtonType.outline,
              icon: AppIcons.pencil,
              iconColor: AppColors.primaryColor, // TODo иконка под вопросом
              title: t.feeding.note,
              onTap: () => onTapNotes!(),
            ),
            10.h,
            CustomButton(
              backgroundColor: AppColors.greenLighterBackgroundColor,
              height: 48,
              width: double.infinity,
              title: t.feeding.confirm,
              textStyle: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.greenTextColor),
              onTap: () => onTapConfirm(),
            ),
            35.h,
          ],
        ),
      ),
    );
  }
}
