import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TableSleepHistory extends StatefulWidget {
  final SleepCryStore store;
  final bool showTitle;
  final String? title;
  final String? childId;

  const TableSleepHistory({
    super.key,
    required this.store,
    required this.showTitle,
    this.title,
    this.childId,
  });

  @override
  State<TableSleepHistory> createState() => _TableSleepHistoryState();
}

class _TableSleepHistoryState extends State<TableSleepHistory> {
  @override
  void initState() {
    widget.store.loadPage(newFilters: [
      SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: widget.childId),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              if (widget.showTitle) ...[
                20.h,
                Text(
                  widget.title ?? t.feeding.story,
                  style: textTheme.titleLarge
                      ?.copyWith(color: Colors.black, fontSize: 20),
                )
              ],
              15.h,
              Row(
                children: [
                  CustomToggleButton(
                      alignment: Alignment.topLeft,
                      items: [t.feeding.newS, t.feeding.old],
                      onTap:
                          (index) {}, // TODO переключение между новыми и старыми
                      btnWidth: 64,
                      btnHeight: 26),
                  Expanded(
                    child: Row(
                      children: [
                        const Spacer(),
                        CustomButton(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          icon: AppIcons.arrowDownToLineCompact,
                          title: t.trackers.pdf.title,
                          height: 26,
                          width: 70,
                          onTap: () {}, // TODO скачать pdf
                        )
                      ],
                    ),
                  )
                ],
              ),
              15.h,
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SkitTableWidget(
            store: widget.store,
          ),
        ),
        // SliverToBoxAdapter(
        //   child: widget.store.rows
        //           .isNotEmpty // проверяет если больше 10 кнопка добавить еще
        //       ? InkWell(
        //           onTap: () {}, // TODO добавить еще строки
        //           child: Column(
        //             children: [
        //               Text(t.feeding.wholeStory, style: textTheme.labelLarge),
        //               const Icon(AppIcons.chevronCompactDown)
        //             ],
        //           ),
        //         )
        //       : const SizedBox.shrink(),
        // ),
      ],
    );
  }
}
