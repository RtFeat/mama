import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:skit/skit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
  String? _currentChildId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final childId = context.read<UserStore>().selectedChild?.id;
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      widget.store.loadPage(newFilters: [
        SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
      ]);
    }
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
                      onTap: () {
                        PdfService.generateAndViewFeedPdf(
                          context: context,
                          typeOfPdf: 'feed',
                          title: t.feeding.story,
                          onStart: () => _showSnack(context, 'Генерация PDF...', bg: const Color(0xFFE1E6FF)),
                          onSuccess: () => _showSnack(context, 'PDF успешно создан!', bg: const Color(0xFFDEF8E0), seconds: 3),
                          onError: (message) => _showSnack(context, message),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          15.h,
          Observer(builder: (_) {
            final data = widget.store.listData;
            if (data.isEmpty) return const SizedBox.shrink();

            final headerStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: AppColors.greyBrighterColor,
            );
            final cellStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
            );

            final header = Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Expanded(flex: 2, child: Text(t.trackers.feedTableTitles.title1, style: headerStyle, textAlign: TextAlign.left)),
                  Expanded(child: Text(t.trackers.feedTableTitles.title2, style: headerStyle, textAlign: TextAlign.center)),
                  Expanded(child: Text(t.trackers.feedTableTitles.title3, style: headerStyle, textAlign: TextAlign.center)),
                  Expanded(child: Text(t.trackers.feedTableTitles.title4, style: headerStyle, textAlign: TextAlign.center)),
                ],
              ),
            );

            final children = <Widget>[header, const SizedBox(height: 8)];
            for (final month in data) {
              final rows = month.table ?? const <FeedingCellTable>[];
              if (rows.isEmpty) continue;
              children.add(Text(month.title ?? '', style: textTheme.titleMedium?.copyWith(fontSize: 17, color: Colors.black)));
              for (final r in rows) {
                children.add(Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: Text(r.title ?? '', style: cellStyle)),
                      Expanded(child: Text(r.chest ?? '', style: cellStyle, textAlign: TextAlign.center)),
                      Expanded(child: Text(r.food ?? '', style: cellStyle, textAlign: TextAlign.center)),
                      Expanded(child: Text(r.lure ?? '', style: cellStyle, textAlign: TextAlign.center)),
                    ],
                  ),
                ));
              }
              children.add(const SizedBox(height: 12));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            );
          }),
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

  void _showSnack(BuildContext ctx, String message, {Color? bg, int seconds = 2}) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        // Определяем цвет текста в зависимости от сообщения
        Color textColor = Colors.white; // по умолчанию
        if (message == 'Генерация PDF...') {
          textColor = const Color(0xFF4D4DE8); // primaryColor
        } else if (message == 'PDF успешно создан!') {
          textColor = const Color(0xFF059613); // greenLightTextColor
        }
        
        ScaffoldMessenger.of(ctx)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            backgroundColor: bg,
            duration: Duration(seconds: seconds),
          ));
      } catch (e) {
        // Ignore snackbar errors
      }
    });
  }
}
