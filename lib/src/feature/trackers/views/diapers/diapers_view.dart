import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class DiapersView extends StatelessWidget {
  const DiapersView({
    super.key,
    this.isTrue = false,
  });

  final bool? isTrue;

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextDiapers,
      onPressClose: () {},
      onPressLearnMore: () {},
      appBar: CustomAppBar(
        title: t.trackers.diapers,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: AppColors.trackerColor, fontSize: 20),
      ),
      stackWidget:

          /// #bottom buttons
          Align(
        alignment: Alignment.bottomCenter,
        child: ButtonsLearnPdfAdd(
          onTapLearnMore: () {},
          onTapPDF: () {},
          onTapAdd: () {
            context.pushNamed(AppViews.addDiaper);
          },
          iconAddButton: AppIcons.diaperFill,
        ),
      ),
      children: [
        20.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
              ),
              onPressed: () {},
            ),
            Column(
              children: [
                Text(
                  '11 сентября - 17 сентября',
                  style: AppTextStyles.f14w400,
                ),
                Text(
                  t.trackers.diaperforday,
                  style: AppTextStyles.f10w400,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        10.h,
        // Основное содержимое календаря

        BuildDaySection('17\nсентября', [
          BuilldGridItem(
            '09:56',
            t.trackers.wet.wet,
            t.trackers.wet.many,
            AppColors.purpleLighterBackgroundColor,
            AppColors.primaryColor,
          ),
          BuilldGridItem(
            '11:25',
            t.trackers.dirty.dirty,
            t.trackers.dirty.solid,
            AppColors.yellowBackgroundColor,
            AppColors.orangeTextColor,
          ),
          BuilldGridItem(
            '13:30',
            t.trackers.mixed.mixed,
            t.trackers.mixed.soft,
            AppColors.greenLighterBackgroundColor,
            AppColors.greenTextColor,
          ),
          BuilldGridItem(
            '15:00',
            t.trackers.wet.wet,
            t.trackers.wet.average,
            AppColors.purpleLighterBackgroundColor,
            AppColors.primaryColor,
          ),
          BuilldGridItem(
            '18:00',
            t.trackers.mixed.mixed,
            t.trackers.mixed.soft,
            AppColors.greenLighterBackgroundColor,
            AppColors.greenTextColor,
          ),
          BuilldGridItem(
            '20:00',
            t.trackers.wet.wet,
            t.trackers.wet.littleBit,
            AppColors.purpleLighterBackgroundColor,
            AppColors.primaryColor,
          ),
        ]),
        const SizedBox(height: 70),
      ],
    );
  }
}
