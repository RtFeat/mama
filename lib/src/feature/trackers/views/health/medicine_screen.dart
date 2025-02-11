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

    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextMedicines,
      onPressClose: () {},
      onPressLearnMore: () {},
      stackWidget:

          /// #bottom buttons
          Provider(
              create: (context) => DrugViewStore(
                  model: medicineStore.drug,
                  restClient: context.read<Dependencies>().restClient),
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
                            return AddMedicine(
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
        Column(
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

            /// #pill
            const PillContainer(), // TODO редактирование лекарства
          ],
        ),
      ],
    );
  }
}
