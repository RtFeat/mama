import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep_table_store.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry_table_store.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class TableSleepHistory extends StatefulWidget {
  final SleepCryStore store;
  final bool showTitle;
  final String? title;
  final String? childId;
  final DateTime? startOfWeek;

  const TableSleepHistory({
    super.key,
    required this.store,
    required this.showTitle,
    this.title,
    this.childId,
    this.startOfWeek,
  });

  @override
  State<TableSleepHistory> createState() => _TableSleepHistoryState();
}

class _TableSleepHistoryState extends State<TableSleepHistory> {
  bool _showAll = false; // Показать всю историю или ограничить первыми N строками
  static const int _initialRowLimit = 5;
  String? _currentChildId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;
    
    final childId = widget.childId;
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      _loadData();
    }
  }

  @override
  void didUpdateWidget(TableSleepHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем данные при смене недели или ребенка
    if (oldWidget.startOfWeek != widget.startOfWeek || 
        oldWidget.childId != widget.childId) {
      _loadData();
    }
  }

  void _loadData() {
    final childId = widget.childId;
    if (childId == null) return;
    
    // Проверяем доступность провайдеров перед использованием
    try {
      final sleepStore = context.read<SleepTableStore>();
      final cryStore = context.read<CryTableStore>();
      
      // Загружаем данные сна
      final restClient = context.read<RestClient>();
      restClient.sleepCry.getSleepCrySleepGet(
        childId: childId,
      ).then((response) {
        if (!mounted) return;
        if (response != null && response.list != null) {
          sleepStore.listData.clear();
          sleepStore.listData.addAll(response.list!);
        }
      }).catchError((error) {
        if (!mounted) return;
      });
      
      // Загружаем данные плача
      restClient.sleepCry.getSleepCryCryGet(
        childId: childId,
      ).then((response) {
        if (!mounted) return;
        if (response != null && response.list != null) {
          cryStore.listData.clear();
          cryStore.listData.addAll(response.list!);
        }
      }).catchError((error) {
        if (!mounted) return;
      });
    } on ProviderNotFoundException catch (e) {
      // Если провайдеры недоступны, просто пропускаем загрузку
    }
  }

  Widget _buildSleepCryReport() {
  return Observer(
      builder: (context) {
        try {
          // Безопасная проверка доступности провайдеров
          SleepTableStore? sleepStore;
          CryTableStore? cryStore;

          try {
            sleepStore = context.read<SleepTableStore>();
            cryStore = context.read<CryTableStore>();
          } catch (e) {
            // Если провайдеры недоступны, показываем сообщение
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Данные недоступны в этом контексте'),
              ),
            );
          }

          final theme = Theme.of(context);
          final headerStyle = theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: const Color(0xFF666E80),
          );
          final dateStyle = theme.textTheme.titleMedium?.copyWith(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          );
          final smallHint = theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w400,
          );
          final cellStyle = theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
          );
          final textTheme = theme.textTheme;

          // Получаем текущую выбранную неделю
          final startOfWeek = widget.startOfWeek ?? DateTime.now();
          final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59));

          // Группируем данные по датам
          final Map<String, Map<String, Duration>> dailyData = {};
          final Map<String, bool> dailySleepHasNotes = {}; // отметка о заметках сна за день
          final Map<String, bool> dailyCryHasNotes = {};   // отметка о заметках плача за день
          // Для исключения дублей одинаковых интервалов внутри дня
          final Map<String, Set<String>> dailyPairsSleep = {};

          // Обрабатываем данные сна
          for (final sleep in sleepStore.listData) {
            // Используем timeEnd для получения правильной даты (как в отдельных экранах)
            final endTime = _parseDateTime(sleep.timeEnd);
            if (endTime == null) continue;

            // Создаем правильную дату для времени начала, используя дату из timeEnd
            DateTime? startTime;
            if (sleep.timeToStart != null && sleep.timeToStart!.contains(':')) {
              final timeParts = sleep.timeToStart!.split(':');
              if (timeParts.length == 2) {
                final hour = int.parse(timeParts[0]);
                final minute = int.parse(timeParts[1]);
                startTime = DateTime(
                    endTime.year, endTime.month, endTime.day, hour, minute);
              }
            } else {
              startTime = _parseDateTime(sleep.timeToStart);
            }

            if (startTime == null) continue;


            // Фильтруем события, которые попадают в выбранную неделю
            // Событие должно начинаться или заканчиваться в пределах недели
            if (endTime.isBefore(startOfWeek) || startTime.isAfter(endOfWeek)) {
              continue; // Событие полностью вне выбранной недели
            }


            final date = DateFormat('dd MMMM').format(endTime);

            if (!dailyData.containsKey(date)) {
              dailyData[date] = {'sleep': Duration.zero, 'cry': Duration.zero};
            }
            // Помечаем наличие заметки для сна
            if ((sleep.notes != null && sleep.notes!.trim().isNotEmpty)) {
              dailySleepHasNotes[date] = true;
            }

            // Вычисляем продолжительность сна
            int durationMinutes = 0;

            durationMinutes = _parseMinutesFromString(sleep.timeToEnd);

            if (durationMinutes == 0) {
              if (endTime.isBefore(startTime)) {
                final adjustedEndTime = endTime.add(const Duration(days: 1));
                durationMinutes =
                    adjustedEndTime.difference(startTime).inMinutes;
              } else {
                durationMinutes = endTime.difference(startTime).inMinutes;
              }
            }


             if (durationMinutes > 0 && durationMinutes < 24 * 60) {
               final endTimeForLabel = _parseDateTime(sleep.timeEnd);
               final startTimeForLabel = _parseDateTimeWithReference(sleep.timeToStart, endTimeForLabel);
               if (startTimeForLabel != null && endTimeForLabel != null) {
                 final startLabel = DateFormat('HH:mm').format(startTimeForLabel);
                 final endLabel = DateFormat('HH:mm').format(endTimeForLabel);
                 final pairKey = '$startLabel|$endLabel';
                 final set = (dailyPairsSleep[date] ??= <String>{});
                 if (!set.contains(pairKey)) {
                   set.add(pairKey);
                   final duration = Duration(minutes: durationMinutes);
                   dailyData[date]!['sleep'] =
                       dailyData[date]!['sleep']! + duration;
                 }
               }
             }
          }

          // Обрабатываем данные плача
          for (final cry in cryStore.listData) {
            final endTime = _parseDateTime(cry.timeEnd);
            if (endTime == null) continue;

            DateTime? startTime;
            if (cry.timeToStart != null && cry.timeToStart!.contains(':')) {
              final timeParts = cry.timeToStart!.split(':');
              if (timeParts.length == 2) {
                final hour = int.parse(timeParts[0]);
                final minute = int.parse(timeParts[1]);
                startTime = DateTime(
                    endTime.year, endTime.month, endTime.day, hour, minute);
              }
            } else {
              startTime = _parseDateTime(cry.timeToStart);
            }

            if (startTime == null) continue;


            // Фильтруем события, которые попадают в выбранную неделю
            // Событие должно начинаться или заканчиваться в пределах недели
            if (endTime.isBefore(startOfWeek) || startTime.isAfter(endOfWeek)) {
              continue; // Событие полностью вне выбранной недели
            }


            final date = DateFormat('dd MMMM').format(endTime);

            if (!dailyData.containsKey(date)) {
              dailyData[date] = {'sleep': Duration.zero, 'cry': Duration.zero};
            }
            // Помечаем наличие заметки для плача
            if ((cry.notes != null && cry.notes!.trim().isNotEmpty)) {
              dailyCryHasNotes[date] = true;
            }

            // Вычисляем продолжительность плача
            int durationMinutes = 0;
            
            // Сначала пытаемся получить продолжительность из all_cry (если есть)
            durationMinutes = _parseMinutesFromString(cry.allCry);
            
            // Если не удалось получить продолжительность из all_cry, вычисляем из startTime и endTime
            if (durationMinutes == 0) {
              if (endTime.isBefore(startTime)) {
                final adjustedEndTime = endTime.add(const Duration(days: 1));
                durationMinutes = adjustedEndTime.difference(startTime).inMinutes;
              } else {
                durationMinutes = endTime.difference(startTime).inMinutes;
              }
            }


            if (durationMinutes > 0 && durationMinutes < 24 * 60) { // меньше 24 часов
              final duration = Duration(minutes: durationMinutes);
              dailyData[date]!['cry'] = dailyData[date]!['cry']! + duration;
            }
          }


          if (dailyData.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Нет данных за выбранную неделю'),
              ),
            );
          }

          final sortedEntries = dailyData.entries.toList()
            ..sort((a, b) {
              final dateA = _parseDateFromString(a.key);
              final dateB = _parseDateFromString(b.key);
              return dateB.compareTo(dateA);
            });

          int remaining = _showAll ? 1 << 30 : _initialRowLimit;
          final List<MapEntry<String, Map<String, Duration>>> limitedSections =
              [];
          for (final entry in sortedEntries) {
            if (remaining <= 0) break;
            limitedSections.add(entry);
            remaining -= 1;
          }

          Map<String, Map<String, Duration>> normalizedSections = {
            for (final e in limitedSections)
              e.key: {
                'sleep': e.value['sleep']!.inMinutes > 24 * 60
                    ? Duration(minutes: 24 * 60)
                    : e.value['sleep']!,
                'cry': e.value['cry']!.inMinutes > 24 * 60
                    ? Duration(minutes: 24 * 60)
                    : e.value['cry']!,
              }
          };

          return Column(
            key: const ValueKey('sleep_cry_report_column'),
            children: [
              Container(
                key: const ValueKey('sleep_cry_header_container'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Дата',
                        style: headerStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Сон',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Плач',
                        style: headerStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...normalizedSections.entries.map((entry) {
                final date = entry.key;
                final data = entry.value;
                final sleepDuration = data['sleep']!;
                final cryDuration = data['cry']!;

                return Container(
                  key: ValueKey('sleep_cry_row_$date'),
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    key: ValueKey('sleep_cry_row_content_$date'),
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          key: ValueKey('sleep_cry_date_$date'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              date,
                              style: dateStyle,
                            ),
                            if ((dailySleepHasNotes[date] == true) || (dailyCryHasNotes[date] == true)) ...[
                              const SizedBox(width: 6),
                              Icon(AppIcons.pencil, size: 14, color: theme.colorScheme.primary.withOpacity(0.6)),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _minutesToHhMm(sleepDuration.inMinutes
                              .clamp(0, 24 * 60)),
                          key: ValueKey('sleep_cry_sleep_$date'),
                          style: cellStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _minutesToHhMm(cryDuration.inMinutes),
                          key: ValueKey('sleep_cry_cry_$date'),
                          style: cellStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              Center(
                child: InkWell(
                  key: const ValueKey('show_all_button'),
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _showAll = !_showAll;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Column(
                      children: [
                        Text(
                          _showAll ? 'Свернуть историю' : 'Вся история',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          _showAll ? Icons.expand_less : Icons.expand_more,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        } catch (e) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Ошибка при загрузке данных'),
            ),
          );
        }
      },
    );
  }
  
  DateTime? _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    try {
      // Если это полная дата с временем
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      } else if (dateTimeString.contains(':')) {
        // Если это только время в формате HH:mm, создаем дату на сегодня
        final timeParts = dateTimeString.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
      } else {
        return DateFormat('yyyy-MM-dd').parse(dateTimeString);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  DateTime? _parseDateTimeWithReference(String? dateTimeString, DateTime? referenceDate) {
    if (dateTimeString == null) return null;
    try {
      // Если это полная дата с временем
      if (dateTimeString.contains('T')) {
        return DateTime.parse(dateTimeString);
      } else if (dateTimeString.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeString);
      } else if (dateTimeString.contains(':')) {
        // Если это только время в формате HH:mm, используем дату из referenceDate
        final timeParts = dateTimeString.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final baseDate = referenceDate ?? DateTime.now();
          return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
        }
      } else {
        return DateFormat('yyyy-MM-dd').parse(dateTimeString);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  int _parseMinutesFromString(String? timeString) {
    if (timeString == null) return 0;
    try {
      // Если это время в формате HH:mm (например, "14:30"), то это время окончания, а не продолжительность
      if (timeString.contains(':') && timeString.length == 5) {
        return 0; // Не можем вычислить продолжительность только по времени окончания
      }
      
      // Если это продолжительность в формате "Xм" или "Xч Yм"
      if (timeString.contains('ч') || timeString.contains('м')) {
        int totalMinutes = 0;
        
        // Ищем часы
        final hourMatch = RegExp(r'(\d+)ч').firstMatch(timeString);
        if (hourMatch != null) {
          totalMinutes += int.parse(hourMatch.group(1)!) * 60;
        }
        
        // Ищем минуты
        final minuteMatch = RegExp(r'(\d+)м').firstMatch(timeString);
        if (minuteMatch != null) {
          totalMinutes += int.parse(minuteMatch.group(1)!);
        }
        
        return totalMinutes;
      }
      
      // Если это просто число (минуты)
      final cleanString = timeString.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanString.isNotEmpty) {
        final result = int.parse(cleanString);
        return result;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String _minutesToHhMm(int minutesTotal) {
    final hours = minutesTotal ~/ 60;
    final minutes = minutesTotal % 60;
    if (hours == 0) return '${minutes}${t.trackers.min}';
    return '${hours}ч ${minutes}${t.trackers.min}';
  }

  DateTime _parseDateFromString(String dateString) {
    try {
      return DateFormat('dd MMMM').parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final theme = Theme.of(context);
      final headerStyle = theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 10,
        color: const Color(0xFF666E80),
      );
      final dateStyle = theme.textTheme.titleMedium?.copyWith(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      );
      final cellStyle = theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
      );
      final textTheme = theme.textTheme;

      return Column(
        key: const ValueKey('table_sleep_history_main_column'),
        children: [
          if (widget.showTitle) ...[
            20.h,
            Text(
              widget.title ?? t.feeding.story,
              style:
                  textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 20),
            )
          ],
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      icon: AppIcons.arrowDownToLineCompact,
                      title: t.trackers.pdf.title,
                      height: 26,
                      width: 70,
                      onTap: () {
                        PdfService.generateAndViewSleepCryPdf(
                          context: context,
                          typeOfPdf: 'sleep_cry',
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
          _buildSleepCryReport(),
          // widget.store.rows.isNotEmpty
          //     ? InkWell(
          //         onTap: () {},
          //         child: Column(
          //           children: [
          //             Text(t.feeding.wholeStory, style: textTheme.labelLarge),
          //             const Icon(AppIcons.chevronCompactDown)
          //           ],
          //         ),
          //       )
          //     : const SizedBox.shrink(),
        ],
      );
    } catch (e) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Ошибка при отображении данных'),
        ),
      );
    }
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