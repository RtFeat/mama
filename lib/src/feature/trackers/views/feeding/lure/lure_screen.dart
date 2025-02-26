import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class LureScreen extends StatefulWidget {
  const LureScreen({super.key});

  @override
  State<LureScreen> createState() => _LureScreenState();
}

class _LureScreenState extends State<LureScreen> {
  var isSwitch = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return TrackerBody(
      learnMoreWidgetText: t.trackers.findOutMoreTextLure,
      onPressClose: () {},
      onPressLearnMore: () {},
      bottomNavigatorBar: Padding(
        padding: const EdgeInsets.all(15),
        child: EditingButtons(
            addBtnText: t.feeding.addComplementaryFood,
            learnMoreTap: () {},
            addButtonTap: () {
              context.pushNamed(AppViews.addLure);
            }),
      ),
      children: [
        15.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomToggleButton(
                items: [t.feeding.newS, t.feeding.old],
                onTap: (index) {},
                btnWidth: 64,
                btnHeight: 26),
            CustomToggleButton(
                items: [t.feeding.all, '🙂', '🤢', '⚠'],
                onTap: (index) {},
                btnWidth: 40,
                btnHeight: 26),
          ],
        ),
        15.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              t.feeding.onlyWithAllergies,
              style: textTheme.labelLarge?.copyWith(
                  color: AppColors.greyBrighterColor,
                  fontWeight: FontWeight.w400),
            ),
            5.w,
            CupertinoSwitch(
                value: isSwitch,
                onChanged: (value) {
                  setState(() {
                    isSwitch = value;
                  });
                })
          ],
        ),
        15.h,
        // TableWidget(
        //     columnTitles: [
        //       t.feeding.time,
        //       t.feeding.food,
        //       t.feeding.quantityAndReaction
        //     ], listOfData: historyOfLure)
      ],
    );
  }
}
