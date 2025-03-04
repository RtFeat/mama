import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final UserStore userStore = context.watch();
    final MedicineStore medicineStore = context.watch();
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle? titlesStyle = textTheme.bodyMedium;

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextMedicines,
      onPressClose: () {},
      onPressLearnMore: () {},
      stackWidget:

          /// #bottom buttons
          Provider(
              create: (context) => DrugViewStore(
                  model: medicineStore.drug,
                  restClient: context.read<Dependencies>().apiClient),
              builder: (context, _) {
                final DrugViewStore store = context.watch();

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonsLearnPdfAdd(
                    onTapLearnMore: () {},
                    onTapPDF: () {},
                    onTapAdd: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Observer(builder: (_) {
                            return AddMedicineView(
                              titlesStyle: titlesStyle,
                              store: store,
                              medicineStore: medicineStore,
                              type: AddMedicineType.add,
                            );
                          }),
                        ),
                      );
                    },
                    iconAddButton: AppIcons.pillsFill,
                  ),
                );
              }),
      children: [
        /// #main content
        SliverToBoxAdapter(
          child: Column(
            children: [
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
                    onChanged: (value) {}, //TODO switcher
                  ),
                ],
              ),
              10.h,

              /// #pill
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          // TODO редактирование лекарства
                        },
                        child: PillAndDocVisitContainer(
                          title: t.trackers.pillTitleOne.title,
                          subTitle: t.trackers.pillDescriptionOne.title,
                          timeDate: t.trackers.pillExactTimeOne.title,
                          description: t.trackers.pillRemainingTimeOne.title,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
