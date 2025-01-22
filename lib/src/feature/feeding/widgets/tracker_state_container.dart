import 'package:flutter/material.dart';
import 'package:mama/src/feature/feeding/state/add_feeding.dart';
import '../../../core/core.dart';

enum ContainerType {
  feedingSaved,
  feedingCanceled,
  sleepingSaved,
  sleepingCanceled,
}

class TrackerStateContainer extends StatelessWidget {
  final ContainerType type;
  final VoidCallback onTapClose;
  final VoidCallback onTapGoBack;
  final VoidCallback? onTapNote;

  const TrackerStateContainer({
    super.key,
    required this.type,
    required this.onTapClose,
    required this.onTapGoBack,
    this.onTapNote,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    String detail;
    switch (type) {
      case ContainerType.feedingSaved:
        title = t.trackers.infoManuallyContainerSaveFeeding.title;
        subtitle = t.trackers.infoManuallyContainerSaveFeeding.text1;
        detail = t.trackers.infoManuallyContainerSaveFeeding.text2;
        break;

      case ContainerType.feedingCanceled:
        title = t.trackers.infoManuallyContainerCancellFeeding.title;
        subtitle = t.trackers.infoManuallyContainerCancellFeeding.text1;
        detail = t.trackers.infoManuallyContainerCancellFeeding.text2;
        break;

      case ContainerType.sleepingCanceled:
        title = t.trackers.infoManuallyContainerCancellSleeping.title;
        subtitle = t.trackers.infoManuallyContainerCancellSleeping.text1;
        detail = t.trackers.infoManuallyContainerCancellSleeping.text2;
        break;

      default:
        title = t.trackers.infoManuallyContainerSaveSleeping.title;
        subtitle = t.trackers.infoManuallyContainerSaveSleeping.text1;
        detail = t.trackers.infoManuallyContainerSaveSleeping.text2;
    }
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
              color: type == ContainerType.feedingSaved
                  ? AppColors.greenTextColor
                  : AppColors.redColor,
              width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 35,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 5,
                      right: 10,
                      left: 10,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: type == ContainerType.feedingCanceled
                                ? AppColors.redColor
                                : AppColors.greenTextColor),
                      ),
                    ),
                    Positioned(
                        top: 5,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            onTapClose();
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.greyColor,
                          ),
                        )),
                  ],
                ),
              ),
              5.h,
              Text(
                subtitle,
                style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyBrighterColor),
              ),
              8.h,
              Text(
                detail,
                style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyBrighterColor),
              ),
              15.h,
              CustomButton(
                backgroundColor: AppColors.greenLighterBackgroundColor,
                height: 48,
                width: double.infinity,
                title: t.trackers.infoManuallyContainerButtonBackAndContinue,
                textStyle: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.greenTextColor),
                onTap: () {
                  onTapGoBack();
                },
              ),
              10.h,
              type == ContainerType.feedingCanceled
                  ? const SizedBox()
                  : CustomButton(
                      height: 48,
                      width: double.infinity,
                      type: CustomButtonType.outline,
                      iconColor: AppColors.primaryColor,
                      icon: AppIcons.pencil,
                      onTap: () {
                        onTapNote!();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
