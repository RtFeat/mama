import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/trackers/widgets/learn_more_widget.dart';
import 'package:skit/skit.dart';

class Medicine extends StatelessWidget {
  const Medicine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// #main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  /// #big find out more button
                  LearnMoreWidget(
                    onPressClose: () {},
                    onPressButton: () {},
                    title: t.trackers.knowMoreOne.title,
                  ),
                  14.h,

                  /// #show completed switch section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        t.trackers.showCompleted.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      /// #
                      CupertinoSwitch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ],
                  ),

                  /// #pill
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteDarkerButtonColor,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: SizedBox(
                      height: 100,
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        children: [
                          /// #pill image
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.purpleLighterBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: const Center(
                                child: Icon(AppIcons.pillsFill),
                                // child: SvgPicture.asset(
                                //   Assets.icons.icPillsFilled,
                                //   width: 28,
                                //   height: 28,
                                // ),
                              ),
                            ),
                          ),
                          16.w,

                          /// #pill details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8)
                                  .copyWith(right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// #pill title
                                  AutoSizeText(
                                    t.trackers.pillTitleOne.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  8.h,

                                  /// #pill description
                                  AutoSizeText(
                                    t.trackers.pillDescriptionOne.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  8.h,

                                  /// #pill exact time, pill remaining time
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// #pill exact time
                                      AutoSizeText(
                                        t.trackers.pillExactTimeOne.title,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      /// #pill remaining time
                                      AutoSizeText(
                                        t.trackers.pillRemainingTimeOne.title,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// #bottom buttons
            ColoredBox(
              color: AppColors.whiteColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(
                  top: 8,
                ),
                child: Row(
                  children: [
                    /// #find out more button
                    Expanded(
                      child: CustomButton(
                        title: t.trackers.knowMoreText.title,
                        onTap: () {},
                        iconColor: AppColors.primaryColor,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                        icon: AppIcons.graduationcapFill,
                        // icon: IconModel(
                        //   iconPath: Assets.icons.icGraduationCapFilled,
                        // ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        type: CustomButtonType.outline,
                      ),
                    ),
                    8.w,

                    /// #pdf button
                    Expanded(
                      child: CustomButton(
                        onTap: () {},
                        title: t.trackers.pdf.title,
                        backgroundColor: AppColors.whiteColor,
                        iconColor: AppColors.primaryColor,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                        // icon: IconModel(
                        //   iconPath: Assets.icons.icArrowDownFilled,
                        // ),
                        icon: AppIcons.arrowDownToLineCompact,
                        type: CustomButtonType.outline,
                      ),
                    ),
                    8.w,

                    /// #add temperature button
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        title: t.trackers.add.title,
                        backgroundColor: AppColors.purpleLighterBackgroundColor,
                        onTap: () {
                          // context.pushNamed();
                        },
                        // onTap: () => _navigateToAddMedicineView(context),
                        // icon: IconModel(
                        //   iconPath: Assets.icons.icPillsFilled,
                        // ),
                        icon: AppIcons.pillsFill,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
