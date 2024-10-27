import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/core/utils/router.dart';
import 'package:mama/src/feature/feeding/data/repository/history_repository.dart';
import 'package:mama/src/feature/feeding/widgets/widget.dart';

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
    return FeedingBody(
      bottomNavigatorBar: Padding(
        padding: const EdgeInsets.all(15),
        child: FeedingButtons(
            addBtnText: 'Добавить прикорм',
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
                items: const ['Новые', 'Старые'],
                onTap: (index) {},
                btnWidth: 64,
                btnHeight: 26),
            CustomToggleButton(
                items: const ['Все', '🙂', '🤢', '⚠'],
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
              'Только\nс аллергией',
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
        TableWidget(
            columnTitles: [
              "Время",
              'Продукт',
              'Кол-во и\nреакция'
            ], listOfData: historyOfLure)
      ],
    );
  }
}
