import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/trackers/views/health/add_medicine.dart';
import 'package:mama/src/feature/trackers/widgets/big_find_out_more_button.dart';

class Medicine extends StatelessWidget {
  const Medicine({super.key});

  void _navigateToAddMedicineView(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddMedicine(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final phonePadding = MediaQuery.of(context).padding;
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
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
                  BigFindOutMoreButton(
                    closeButtonOnPressed: () {},
                    findOutMoreButtonOnPressed: () {},
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
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        children: [
                          /// #pill image
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.purpleLighterBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: Center(
                                child: SvgPicture.asset(
                                  Assets.icons.icPillsFilled,
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

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
                                  const SizedBox(height: 8),

                                  /// #pill description
                                  AutoSizeText(
                                    t.trackers.pillDescriptionOne.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // const SizedBox(height: 8),

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
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                  top: 8,
                  bottom: phonePadding.bottom + 16,
                ),
                child: Row(
                  children: [
                    /// #find out more button
                    Expanded(
                      child: CustomButton(
                        title: t.trackers.findOutMore.title,
                        onTap: () {},
                        icon: IconModel(
                          iconPath: Assets.icons.icGraduationCapFilled,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        type: CustomButtonType.outline,
                        textStyle: textTheme.titleMedium!.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    8.w,

                    /// #pdf button
                    Expanded(
                      child: CustomButton(
                        title: t.trackers.pdf.title,
                        onTap: () {},
                        icon: IconModel(
                          iconPath: Assets.icons.icArrowDownFilled,
                        ),
                        type: CustomButtonType.outline,
                      ),
                    ),
                    8.w,

                    /// #add temperature button
                    Expanded(
                      child: CustomButton(
                        title: t.trackers.add.title,
                        onTap: () {
                          // context.pushNamed(AppViews.trackersHealthAddMedicineView);
                          _navigateToAddMedicineView(context);
                        },
                        icon: IconModel(
                          iconPath: Assets.icons.icPillsFilled,
                        ),
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
