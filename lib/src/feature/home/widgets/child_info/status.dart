import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ChildStatusWidget extends StatelessWidget {
  const ChildStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch();
    final ChildModel? child = userStore.selectedChild;

    final ChildStatus? status = child?.status;

    final ChildStatusType? type = status?.value;

    return Observer(builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.whiteColor,
                        switch (type) {
                          ChildStatusType.birth => AppColors.yellowColor,
                          ChildStatusType.drug =>
                            AppColors.redChildStatusBackgroundColor,
                          ChildStatusType.vaccination =>
                            AppColors.blueChildStatusBackgroundColor,
                          ChildStatusType.good =>
                            AppColors.purpleChildStatusBackgroundColor,
                          _ => AppColors.yellowColor,
                        },
                      ],
                    ).createShader(bounds);
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: switch (type) {
                        ChildStatusType.birth => AppColors.yellowColor,
                        ChildStatusType.drug =>
                          AppColors.redChildStatusBackgroundColor,
                        ChildStatusType.vaccination =>
                          AppColors.blueChildStatusBackgroundColor,
                        ChildStatusType.good =>
                          AppColors.purpleChildStatusBackgroundColor,
                        _ => AppColors.yellowColor,
                      },
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Title(),
                          if (type == ChildStatusType.vaccination)
                            Row(
                              children: [
                                IconWidget(
                                    model: IconModel(
                                  icon: AppIcons.rectanglesGroup,
                                  // iconPath: Assets.icons.icBnServicesTap.path,
                                  size: const Size(32, 32),
                                )),
                                8.w,
                                Expanded(
                                  child: AutoSizeText(
                                    t.home.clickToSeeMore,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                  ),
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// #icon
          if (type != null)
            Positioned(
              top: -40,
              left: 10,
              child: Text(
                switch (type) {
                  ChildStatusType.birth => '🥳',
                  ChildStatusType.drug => '💊',
                  ChildStatusType.vaccination => '💉',
                  ChildStatusType.good => '🙂',
                  _ => '🥳',
                },
                style: const TextStyle(fontSize: 50),
              ),
            ),
        ],
      );
    });
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final UserStore userStore = context.watch();

    return Observer(builder: (context) {
      final ChildModel? child = userStore.selectedChild;
      String getAgeText(DateTime birthDate, [bool isMale = false]) {
        final now = DateTime.now();
        final ageInDays = now.difference(birthDate).inDays;

        if (ageInDays < 7) {
          return isMale ? t.home.bornMale.title : t.home.bornFemale.title;
        } else if (ageInDays < 14) {
          return t.home.firstWeek.title;
        } else if (ageInDays < 21) {
          return t.home.twoWeeks.title;
        } else if (ageInDays < 28) {
          return t.home.threeWeeks.title;
        } else if (ageInDays < 31) {
          return t.home.alreadyMonth.title;
        } else if (ageInDays < 61) {
          return t.home.twoMonths.title;
        } else if (ageInDays < 91) {
          return t.home.threeMonths.title;
        } else if (ageInDays < 122) {
          return t.home.fourMonths.title;
        } else if (ageInDays < 153) {
          return t.home.fiveMonths.title;
        } else if (ageInDays < 214) {
          return t.home.soonSixMonths.title;
        } else if (ageInDays < 365) {
          return t.home.alreadySixMonths.title;
        } else {
          return '';
        }
      }

      return AutoSizeText(
        child?.status != null && child!.status!.title.isNotEmpty
            ? child.status!.title
            : getAgeText(child?.birthDate ?? DateTime.now(),
                child?.gender == Gender.male),
        maxLines: 2,
        style: textTheme.headlineSmall?.copyWith(
          fontSize: 20,
          height: 1.26,
          fontWeight: FontWeight.w700,
        ),
      );
    });
  }
}
