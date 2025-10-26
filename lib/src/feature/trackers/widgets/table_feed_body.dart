import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:skit/skit.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  Map<String, String> _chestTimeCache = {};

  @override
  void initState() {
    super.initState();
  }

  /// Исправляет заголовок на основе реального возраста ребенка
  String _fixTitle(String? originalTitle) {
    if (originalTitle == null || originalTitle.isEmpty) return '';
    
    // Если заголовок содержит "12 месяцев", проверяем реальный возраст ребенка
    if (originalTitle.contains('12 месяцев')) {
      final child = context.read<UserStore>().selectedChild;
      if (child?.birthDate != null) {
        final now = DateTime.now();
        final birthDate = child!.birthDate!.toLocal();
        final difference = now.difference(birthDate);
        
        final months = (difference.inDays / 30).floor();
        final days = difference.inDays - (months * 30);
        
        // Если ребенку меньше 1 месяца, показываем возраст в неделях
        if (months < 1) {
          final weeks = difference.inDays ~/ 7;
          
          if (weeks > 0) {
            // Если 4 недели или больше, показываем как месяцы
            if (weeks >= 4) {
              final monthsFromWeeks = weeks ~/ 4;
              final remainingWeeks = weeks % 4;
              
              if (remainingWeeks > 0) {
                return '$monthsFromWeeks ${monthsFromWeeks == 1 ? 'месяц' : monthsFromWeeks < 5 ? 'месяца' : 'месяцев'} $remainingWeeks ${remainingWeeks == 1 ? 'неделя' : remainingWeeks < 5 ? 'недели' : 'недель'}';
              } else {
                return '$monthsFromWeeks ${monthsFromWeeks == 1 ? 'месяц' : monthsFromWeeks < 5 ? 'месяца' : 'месяцев'}';
              }
            } else {
              return '$weeks ${weeks == 1 ? 'неделя' : weeks < 5 ? 'недели' : 'недель'}';
            }
          } else {
            // Если меньше недели, показываем дни
            final days = difference.inDays;
            return '$days ${days == 1 ? 'день' : days < 5 ? 'дня' : 'дней'}';
          }
        } else {
          // Если ребенку 1 месяц или больше, показываем возраст в месяцах и днях
          return '$months ${months == 1 ? 'месяц' : months < 5 ? 'месяца' : 'месяцев'} $days ${days == 1 ? 'день' : days < 5 ? 'дня' : 'дней'}';
        }
      }
    }
    
    return originalTitle;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final childId = context.read<UserStore>().selectedChild?.id;
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      // Store теперь сам управляет загрузкой данных при смене ребенка
      // Просто активируем store если он неактивен
      widget.store.activate();
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
                          onSuccess: () {},
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
              children.add(Text(_fixTitle(month.title), style: textTheme.titleMedium?.copyWith(fontSize: 17, color: Colors.black)));
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
                      Expanded(
                        child: FutureBuilder<String>(
                          future: _calculateBreastFeedingTimeForDay(r.title),
                          builder: (context, snapshot) {
                            final chestTime = snapshot.data ?? r.chest ?? '';
                            return Text(chestTime, style: cellStyle, textAlign: TextAlign.center);
                          },
                        ),
                      ),
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

  String _minutesToHhMm(int minutesTotal) {
    final hours = minutesTotal ~/ 60;
    final minutes = minutesTotal % 60;
    if (hours == 0) return '${minutes}${t.trackers.min}';
    return '${hours}ч ${minutes}${t.trackers.min}';
  }

  Future<String> _calculateBreastFeedingTimeForDay(String? dayTitle) async {
    if (dayTitle == null || dayTitle.isEmpty) return '';
    
    // Check cache first
    if (_chestTimeCache.containsKey(dayTitle)) {
      return _chestTimeCache[dayTitle]!;
    }

    try {
      final childId = context.read<UserStore>().selectedChild?.id;
      if (childId == null) return '';

      final deps = context.read<Dependencies>();
      
      // Parse the date from dayTitle (format: "dd MMMM")
      final inputFormat = DateFormat('dd MMMM', 'ru');
      DateTime targetDate;
      try {
        targetDate = inputFormat.parse(dayTitle);
      } catch (e) {
        // If parsing fails, try to extract date from the string
        final match = RegExp(r'(\d+)\s+(\w+)').firstMatch(dayTitle);
        if (match != null) {
          final day = int.parse(match.group(1)!);
          final monthName = match.group(2)!;
          final monthMap = {
            'января': 1, 'февраля': 2, 'марта': 3, 'апреля': 4,
            'мая': 5, 'июня': 6, 'июля': 7, 'августа': 8,
            'сентября': 9, 'октября': 10, 'ноября': 11, 'декабря': 12
          };
          final month = monthMap[monthName.toLowerCase()];
          if (month != null) {
            targetDate = DateTime(DateTime.now().year, month, day);
          } else {
            return '';
          }
        } else {
          return '';
        }
      }
      
      // Fetch all chest history (we'll filter by date)
      final response = await deps.restClient.feed.getFeedChestHistory(
        childId: childId,
        pageSize: 1000, // Get a large number to ensure we get all data
      );
      
      if (response.list == null) return '';
      
      // Calculate total minutes for the target day
      int totalMinutes = 0;
      for (final chestData in response.list!) {
        if (chestData.chestHistory != null) {
          // Check if this chest data is for the target date
          final chestDate = _parseChestDate(chestData.timeToEndTotal);
          if (chestDate != null && _isSameDay(chestDate, targetDate)) {
            for (final chest in chestData.chestHistory!) {
              totalMinutes += chest.total ?? 0;
            }
          }
        }
      }
      
      final result = totalMinutes > 0 ? _minutesToHhMm(totalMinutes) : '';
      _chestTimeCache[dayTitle] = result;
      return result;
    } catch (e) {
      return '';
    }
  }

  DateTime? _parseChestDate(String? timeToEndTotal) {
    if (timeToEndTotal == null || timeToEndTotal.isEmpty) return null;
    try {
      if (timeToEndTotal.contains('T')) {
        return DateTime.parse(timeToEndTotal);
      }
      if (timeToEndTotal.contains(' ')) {
        // Try to parse as "dd MMMM" format first
        try {
          return DateFormat('dd MMMM', 'ru').parse(timeToEndTotal);
        } catch (e) {
          // If that fails, try ISO format
          return DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeToEndTotal);
        }
      }
      return DateFormat('yyyy-MM-dd').parse(timeToEndTotal);
    } catch (e) {
      return null;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
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
