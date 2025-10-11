import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:mama/src/core/api/models/sleepcry_delete_sleep_dto.dart';

class SleepHistoryTableWidget extends StatefulWidget {
  const SleepHistoryTableWidget({super.key});

  @override
  State<SleepHistoryTableWidget> createState() => _SleepHistoryTableWidgetState();
}

class _SleepHistoryTableWidgetState extends State<SleepHistoryTableWidget> {
  int sortIndex = 0; // 0 -> new first, 1 -> old first
  bool _showAll = false; // Показать всю историю или ограничить первыми N записями
  static const int _initialRowLimit = 5;

  String? _currentChildId;

  bool _isUuid(String? value) {
    if (value == null) return false;
    final uuidRegExp = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}?$');
    return uuidRegExp.hasMatch(value);
  }

  Future<String?> _resolveSleepId(Dependencies deps, String childId, EntitySleep rec) async {
    try {
      // Сначала проверяем, есть ли уже UUID в локальных данных
      if (_isUuid(rec.id)) {
        return rec.id;
      }

      final start = _parseDateTime(rec.timeToStart);
      // Диапазон на весь день записи
      final dayStart = DateTime(start.year, start.month, start.day, 0, 0, 0);
      final dayEnd = DateTime(start.year, start.month, start.day, 23, 59, 59, 999);

      final resp = await deps.restClient.sleepCry
          .getSleepCrySleepGet(
            childId: childId,
            fromTime: dayStart.toUtc().toIso8601String(),
            toTime: dayEnd.toUtc().toIso8601String(),
          );

      final list = resp.list ?? const <EntitySleep>[];
      // Сопоставляем по времени. Учитываем возможные различия форматов (ISO/HH:mm и т.п.).
      final recStart = _parseDateTime(rec.timeToStart);
      final recEnd = _parseDateTime(rec.timeEnd);
      final hhmm = DateFormat('HH:mm');
      final recStartHHmm = hhmm.format(recStart);
      final recEndHHmm = hhmm.format(recEnd);

      for (final e in list) {
        if (!_isUuid(e.id)) continue;
        final eStart = _parseDateTime(e.timeToStart);
        final eEnd = _parseDateTime(e.timeEnd);
        final sameDay = eStart.year == recStart.year && eStart.month == recStart.month && eStart.day == recStart.day;
        final startMatch = e.timeToStart == rec.timeToStart || hhmm.format(eStart) == recStartHHmm;
        final endMatch = e.timeEnd == rec.timeEnd || hhmm.format(eEnd) == recEndHHmm;
        if (sameDay && startMatch && endMatch) {
          return e.id;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _getSleepInfoForRecord(EntitySleep record) {
    try {
      // Рассчитываем продолжительность конкретной записи сна
      final start = _parseDateTime(record.timeToStart);
      final end = _parseDateTime(record.timeEnd);
      
      int sleepMinutes;
      if (end.isBefore(start)) {
        final adjustedEnd = end.add(const Duration(days: 1));
        sleepMinutes = adjustedEnd.difference(start).inMinutes;
      } else {
        sleepMinutes = end.difference(start).inMinutes;
      }
      
      final sleepHours = sleepMinutes ~/ 60;
      final sleepMins = sleepMinutes % 60;
      
      // Определяем статус для конкретной записи
      String status;
      String statusColor;
      if (sleepMinutes >= 480) { // 8+ часов = норма
        status = 'Норма';
        statusColor = 'green';
      } else if (sleepMinutes >= 360) { // 6-8 часов = мало сна
        status = 'Мало сна';
        statusColor = 'orange';
      } else { // < 6 часов = очень мало сна
        status = 'Очень мало сна';
        statusColor = 'red';
      }
      
      // Рассчитываем недостаток сна для конкретной записи
      int deficitMinutes = 0;
      if (sleepMinutes < 480) { // Если меньше 8 часов
        deficitMinutes = 480 - sleepMinutes;
      }
      
      final deficitHours = deficitMinutes ~/ 60;
      final deficitMins = deficitMinutes % 60;
      
      return {
        'status': status,
        'statusColor': statusColor,
        'median': '${sleepHours}ч ${sleepMins}м', // Продолжительность этой записи
        'normRange': '8-12ч', // Нормальный диапазон для детей
        'toGain': deficitMinutes > 0 ? '${deficitHours}ч ${deficitMins}м' : '0ч 0м', // Сколько нужно доспать до нормы для этой записи
      };
    } catch (e) {
      // Игнорируем ошибки
    }
    
    return {
      'status': '',
      'statusColor': 'transparent',
      'median': '',
      'normRange': '',
      'toGain': '',
    };
  }

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
      final store = context.read<SleepTableStore>();
      if (store.listData.isEmpty) {
        // Используем только child_id фильтр, так как API не поддерживает from_time и to_time
        store.loadPage(newFilters: [
          SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
        ]);
      }
    }
  }

  DateTime _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null) return DateTime.now();
    try {
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
      return DateTime.now();
    }
    return DateTime.now();
  }

  String _minutesToHhMm(int minutesTotal) {
    final hours = minutesTotal ~/ 60;
    final minutes = minutesTotal % 60;
    if (hours == 0) return '${minutes}${t.trackers.min}';
    return '${hours}ч ${minutes}${t.trackers.min}';
  }

  // Создает правильную дату для времени начала, используя дату из timeEnd и время из timeToStart
  DateTime _parseStartTime(EntitySleep sleep) {
    final endDate = _parseDateTime(sleep.timeEnd);
    if (sleep.timeToStart != null && sleep.timeToStart!.contains(':')) {
      final timeParts = sleep.timeToStart!.split(':');
      if (timeParts.length == 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        return DateTime(endDate.year, endDate.month, endDate.day, hour, minute);
      }
    }
    return endDate;
  }

  void _showSleepDetailsDialog(BuildContext context, List<EntitySleep> allForDay, int startIndex, String dayLabel) async {
    final deps = context.read<Dependencies>();
    final userStore = context.read<UserStore>();
    final sleepTableStore = context.read<SleepTableStore>();
    // Важно: захватываем родительский контекст страницы до открытия диалога,
    // чтобы использовать его для навигации после закрытия диалога
    final pageContext = this.context;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        int index = startIndex;
        return StatefulBuilder(builder: (context, setState) {
          final rec = allForDay[index];
          
          // Получаем информацию о сне для конкретной записи
          final sleepInfo = _getSleepInfoForRecord(rec);
          final start = _parseStartTime(rec);
          DateTime end = _parseDateTime(rec.timeEnd);
          if (end.isBefore(start)) {
            end = end.add(const Duration(days: 1)); // пересекает полночь
          }
          final diff = end.difference(start);
          final duration = _minutesToHhMm(diff.inMinutes);
          
          // Определяем цвет статуса сна
          Color sleepStatusColor = Colors.transparent;
          if (sleepInfo['statusColor'] == 'green') {
            sleepStatusColor = const Color(0xFF4CAF50); // Зеленый
          } else if (sleepInfo['statusColor'] == 'orange') {
            sleepStatusColor = const Color(0xFFFF9800); // Оранжевый
          } else if (sleepInfo['statusColor'] == 'red') {
            sleepStatusColor = const Color(0xFFE53E3E); // Красный
          }
          
          final details = MeasurementDetails(
            title: t.sleep.sleep,
            currentWeek: dayLabel,
            previousWeek: '',
            selectedWeek: dayLabel,
            nextWeek: '',
            weight: duration,
            weightStatus: sleepInfo['status'] ?? '',
            weightStatusColor: sleepStatusColor,
            medianWeight: sleepInfo['median'] ?? '',
            normWeightRange: sleepInfo['normRange'] ?? '',
            weightToGain: sleepInfo['toGain'] ?? '',
            note: rec.notes,
            viewNormsLabel: 'Смотреть нормы сна',
            onClose: () => Navigator.of(dialogContext).pop(),
            onEdit: () {
              final parentContext = pageContext;
              final router = GoRouter.of(parentContext);
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                final res = await router.pushNamed(AppViews.addSleeping, extra: rec);
                if (res == true && parentContext.mounted) {
                  final childId = userStore.selectedChild?.id;
                  sleepTableStore.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                  ]);
                }
              });
            },
            onDelete: rec.id != null && rec.id!.isNotEmpty ? () async {
              // Разрешаем реальный UUID id, если пришел синтетический
              final childId = userStore.selectedChild?.id;
              final id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolveSleepId(deps, childId, rec));
              
              if (id == null) {
                // Если не удалось найти ID на сервере, возможно это локальная запись
                // Удаляем ее локально и показываем сообщение
                if (dialogContext.mounted) {
                  sleepTableStore.listData.removeWhere((e) => e.id == rec.id);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Запись удалена')),
                  );
                }
                return;
              }
              
              deps.restClient.sleepCry
                  .deleteSleepCrySleepDeleteStats(dto: SleepcryDeleteSleepDto(id: id))
                  .then((v) {
                if (dialogContext.mounted) {
                  // Оптимистично удаляем запись из локального списка для мгновенного обновления UI
                  sleepTableStore.listData.removeWhere((e) => e.id == rec.id);
                  Navigator.of(dialogContext).pop();

                  // Фоново обновляем данные с сервера
                  final childId = userStore.selectedChild?.id;
                  sleepTableStore.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                  ]);
                }
              }).catchError((error) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Ошибка при удалении записи: ${error.toString()}')),
                  );
                }
              });
            } : null,
            onNoteEdit: () async {
              // Разрешаем реальный UUID id, если пришел синтетический
              final childId = userStore.selectedChild?.id;
              final id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolveSleepId(deps, childId, rec));
              Navigator.of(dialogContext).pop();
              if (!pageContext.mounted) return;
              final router = GoRouter.of(pageContext);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!pageContext.mounted) return;
                router.pushNamed(AppViews.addNote, extra: {
                  'initialValue': rec.notes,
                  'onSaved': (String value) async {
                    if (id == null) return;
                    await deps.apiClient.patch('sleep_cry/sleep/notes', body: {
                      'id': id,
                      'notes': value,
                    });
                    // Обновляем локально и перезагружаем
                    final idx = sleepTableStore.listData.indexWhere((e) => e.id == rec.id);
                    if (idx >= 0) {
                      final old = sleepTableStore.listData[idx];
                      final updated = EntitySleep(
                        id: old.id,
                        childId: old.childId,
                        timeToStart: old.timeToStart,
                        timeToEnd: old.timeToEnd,
                        timeEnd: old.timeEnd,
                        allSleep: old.allSleep,
                        notes: value,
                      );
                      sleepTableStore.listData[idx] = updated;
                    }
                    final childId2 = userStore.selectedChild?.id;
                    sleepTableStore.loadPage(newFilters: [
                      SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId2),
                    ]);
                  },
                });
              });
            },
            onNoteDelete: rec.notes != null ? () async {
              // Разрешаем реальный UUID id, если пришел синтетический
              final childId = userStore.selectedChild?.id;
              final id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolveSleepId(deps, childId, rec));
              
              if (id == null) {
                // Если не удалось найти ID на сервере, возможно это локальная запись
                // Очищаем заметку локально и показываем сообщение
                if (dialogContext.mounted) {
                  final idx = sleepTableStore.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = sleepTableStore.listData[idx];
                    final updated = EntitySleep(
                      id: old.id,
                      childId: old.childId,
                      timeToStart: old.timeToStart,
                      timeEnd: old.timeEnd,
                      timeToEnd: old.timeToEnd,
                      allSleep: old.allSleep,
                      notes: null, // Очищаем заметку
                    );
                    sleepTableStore.listData.removeAt(idx);
                    sleepTableStore.listData.insert(idx, updated);
                    setState(() {});
                  }
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Заметка удалена')),
                  );
                }
                return;
              }

              deps.restClient.sleepCry
                  .deleteSleepCrySleepDeleteNotes(dto: SleepcryDeleteSleepDto(id: id))
                  .then((v) {
                if (dialogContext.mounted) {
                  // Оптимистично очищаем заметку в локальном списке для мгновенного обновления UI
                  final idx = sleepTableStore.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = sleepTableStore.listData[idx];
                    final updated = EntitySleep(
                      id: old.id,
                      childId: old.childId,
                      timeToStart: old.timeToStart,
                      timeEnd: old.timeEnd,
                      timeToEnd: old.timeToEnd,
                      allSleep: old.allSleep,
                      notes: null, // Очищаем заметку
                    );
                    sleepTableStore.listData.removeAt(idx);
                    sleepTableStore.listData.insert(idx, updated);
                    setState(() {});
                  }
                  
                  // Фоново обновляем данные с сервера
                  final childId = userStore.selectedChild?.id;
                  sleepTableStore.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                  ]);
                }
              }).catchError((error) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Ошибка при удалении заметки: ${error.toString()}')),
                  );
                }
              });
            } : null,
            onNextWeekTap: index < allForDay.length - 1 ? () => setState(() => index++) : null,
            onPreviousWeekTap: index > 0 ? () => setState(() => index--) : null,
          );
          return MeasurementOverlay(details: details);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Observer(builder: (_) {
      final store = context.read<SleepTableStore>();

      // Группируем записи по дате (yyyy-MM-dd) используя timeEnd для получения правильной даты
      final Map<String, List<EntitySleep>> grouped = {};
      for (final e in store.listData) {
        final d = _parseDateTime(e.timeEnd); // Используем timeEnd для получения полной даты
        final k = DateFormat('yyyy-MM-dd').format(d);
        (grouped[k] ??= <EntitySleep>[]).add(e);
      }

      // Отсортированные ключи дат
      final allDateKeys = grouped.keys.toList()
        ..sort((a, b) {
          final da = DateTime.parse(a);
          final db = DateTime.parse(b);
          return sortIndex == 0 ? db.compareTo(da) : da.compareTo(db);
        });

      // Когда показываем не всю историю, ограничим общее число строк первыми N
      final orderedDateKeys = allDateKeys;
      int remaining = _showAll ? 1 << 30 : _initialRowLimit;
      final List<MapEntry<String, List<EntitySleep>>> sections = [];
      for (final dayKey in orderedDateKeys) {
        if (remaining <= 0) break;
        final itemsForDay = List<EntitySleep>.from(grouped[dayKey] ?? const <EntitySleep>[])
          ..sort((a, b) => _parseStartTime(a).compareTo(_parseStartTime(b)));
        final take = remaining < itemsForDay.length ? remaining : itemsForDay.length;
        sections.add(MapEntry(dayKey, itemsForDay.take(take).toList()));
        remaining -= take;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwitchContainer(
                title1: t.trackers.news.title,
                title2: t.trackers.old.title,
                onSelected: (index) {
                  setState(() => sortIndex = index);
                },
              ),
              const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(child: Text('Начало', style: headerStyle, textAlign: TextAlign.left)),
                Expanded(child: Text('Окончание', style: headerStyle, textAlign: TextAlign.center)),
                Expanded(child: Text('Время', style: headerStyle, textAlign: TextAlign.right)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            itemCount: sections.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final inputFormat = DateFormat('yyyy-MM-dd');
              final input = inputFormat.parse(sections[index].key);
              final dateLabel = DateFormat('dd MMMM').format(input);
              final fullDayItems = List<EntitySleep>.from(grouped[sections[index].key] ?? [])
                ..sort((a, b) => _parseDateTime(a.timeToStart).compareTo(_parseDateTime(b.timeToStart)));
              final dayItems = sections[index].value; // отображаемые элементы (могут быть урезаны)

              int totalMinutes = 0;
              final rows = <Widget>[];
              // Убираем дубликаты по паре start|end внутри дня
              final Set<String> usedPairs = <String>{};
              for (var i = 0; i < dayItems.length; i++) {
                final e = dayItems[i];
                final start = _parseStartTime(e);
                DateTime end = _parseDateTime(e.timeEnd);
                if (end.isBefore(start)) {
                  end = end.add(const Duration(days: 1));
                }
                final diff = end.difference(start);
                final minutes = diff.inMinutes;
                final key = '${DateFormat('HH:mm').format(start)}|${DateFormat('HH:mm').format(end)}';
                if (!usedPairs.contains(key)) {
                  usedPairs.add(key);
                  totalMinutes += minutes < 0 ? 0 : minutes;
                }
                rows.add(InkWell(
                  onTap: () => _showSleepDetailsDialog(context, fullDayItems, i, dateLabel),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(start),
                                style: cellStyle,
                                textAlign: TextAlign.left,
                              ),
                              if (i == 0 || i == dayItems.length - 1)
                                Positioned(
                                  left: -18,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Icon(
                                      i == 0
                                          ? AppIcons.arrowTurnLeftUp
                                          : AppIcons.arrowTurnLeftDown,
                                      size: 18,
                                      color: theme.colorScheme.primary.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            DateFormat('HH:mm').format(end),
                            style: cellStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _minutesToHhMm(minutes < 0 ? 0 : minutes),
                            style: cellStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(dateLabel, style: dateStyle, maxLines: 1),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Всего', style: smallHint),
                            const SizedBox(width: 8),
                            Text(
                              _minutesToHhMm(totalMinutes.clamp(0, 24 * 60)),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...rows,
                ],
              );
            },
          ),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  children: [
                    Text(
                      _showAll ? 'Свернуть историю' : 'Вся история',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(_showAll ? Icons.expand_less : Icons.expand_more, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
