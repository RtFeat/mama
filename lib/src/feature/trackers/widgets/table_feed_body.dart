import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TableFeedHistory extends StatefulWidget {
  final FeedingStore store;
  final bool showTitle;
  final String? title;

  const TableFeedHistory({
    super.key,
    required this.store,
    required this.showTitle,
    this.title,
  });

  @override
  State<TableFeedHistory> createState() => _TableFeedHistoryState();
}

class _TableFeedHistoryState extends State<TableFeedHistory> {
  @override
  void initState() {
    widget.store.loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.showTitle
              ? Column(
                  children: [
                    20.h,
                    Text(
                      widget.title ?? t.feeding.story,
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
                  onTap: (index) {}, // TODO переключение между новыми и старыми
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
          widget.store.rows.isNotEmpty
              ? SkitTableWidget(store: widget.store)
              : const SizedBox.shrink(),
          widget.store.rows.length % 10 == 0 &&
                  widget.store.rows
                      .isNotEmpty // проверяет если больше 10 кнопка добавить еще
              ? InkWell(
                  onTap: () {}, // TODO добавить еще строки
                  child: Column(
                    children: [
                      Text(t.feeding.wholeStory, style: textTheme.labelLarge),
                      const Icon(AppIcons.chevronCompactDown)
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          10.h
        ],
      ),
    );
  }
}
