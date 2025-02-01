import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/trackers/data/entity/history_of_feeding.dart';
import 'package:skit/skit.dart';

class TableHistory extends StatelessWidget {
  final List<HistoryOfFeeding> listOfData;
  final String firstColumnName;
  final String secondColumnName;
  final String thirdColumnName;
  final String fourthColumnName;
  final bool showTitle;

  const TableHistory(
      {super.key,
      required this.listOfData,
      required this.firstColumnName,
      required this.secondColumnName,
      required this.thirdColumnName,
      required this.fourthColumnName,
      required this.showTitle});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showTitle
              ? Column(
                  children: [
                    20.h,
                    Text(
                      t.feeding.story,
                      style: textTheme.titleLarge
                          ?.copyWith(color: Colors.black, fontSize: 20),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          15.h,
          Row(
            children: [
              CustomToggleButton(
                  alignment: Alignment.topLeft,
                  items: [t.feeding.newS, t.feeding.old],
                  onTap: (index) {},
                  btnWidth: 64,
                  btnHeight: 26),
              showTitle
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          CustomButton(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            // icon: IconModel(iconPath: Assets.icons.icUpload),
                            icon: AppIcons.arrowDownToLineCompact,
                            title: t.trackers.pdf.title,
                            height: 26,
                            width: 70,
                            onTap: () {},
                          )
                        ],
                      ),
                    )
            ],
          ),
          15.h,
          // TableWidget(
          //   columnTitles: [
          //     firstColumnName,
          //     secondColumnName,
          //     thirdColumnName,
          //     fourthColumnName
          //   ],
          //   listOfData: listOfData,
          // ),
          showTitle
              ? Column(
                  children: [
                    Text(t.feeding.wholeStory, style: textTheme.labelLarge),
                    // SvgPicture.asset(Assets.icons.icArrowDown),
                    const Icon(AppIcons.chevronCompactDown)
                  ],
                )
              : const SizedBox.shrink(),
          10.h
        ],
      ),
    );
  }
}
