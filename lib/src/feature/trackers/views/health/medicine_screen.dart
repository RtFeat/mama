import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final UserStore userStore = context.watch();
    final MedicineStore medicineStore = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle? titlesStyle = textTheme.bodyMedium;
    final phonePadding = MediaQuery.of(context).padding;

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
                    title: t.trackers.findOutMoreTextTemp,
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
                  const PillContainer(),
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
                        title: t.trackers.knowMoreText.title,
                        onTap: () {},
                        icon: AppIcons.graduationcapFill,
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
                        icon: AppIcons.arrowDownToLineCompact,
                        type: CustomButtonType.outline,
                      ),
                    ),
                    8.w,

                    /// #add temperature button
                    Expanded(
                      child: Provider(
                          create: (context) => DrugViewStore(
                              model: medicineStore.drug,
                              restClient:
                                  context.read<Dependencies>().restClient),
                          builder: (context, _) {
                            final DrugViewStore store = context.watch();

                            return CustomButton(
                              title: t.trackers.add.title,
                              maxLines: 1,
                              onTap: () {
                                // context.pushNamed(AppViews.trackersHealthAddMedicineView);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Observer(builder: (_) {
                                      return AddMedicine(
                                        titlesStyle: titlesStyle,
                                        store: store,
                                        medicineStore: medicineStore,
                                      );
                                    }),
                                  ),
                                );
                              },
                              icon: AppIcons.pillsFill,
                            );
                          }),
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
