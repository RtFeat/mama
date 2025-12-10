import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/feeding/pumping_table_store.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/feed_delete_pumping_dto.dart';
// Using t from data.dart for locale

class PumpingHistoryTableWidgetWrapper extends StatelessWidget {
  final void Function(bool showSavedBanner)? showSavedBanner;
  const PumpingHistoryTableWidgetWrapper({super.key, this.showSavedBanner});

  @override
  Widget build(BuildContext context) {
    return PumpingHistoryTableWidget(showSavedBanner: showSavedBanner);
  }
}

class PumpingHistoryTableWidget extends StatefulWidget {
  final void Function(bool showSavedBanner)? showSavedBanner;
  const PumpingHistoryTableWidget({super.key, this.showSavedBanner});

  @override
  State<PumpingHistoryTableWidget> createState() => _PumpingHistoryTableWidgetState();
}

class _PumpingHistoryTableWidgetState extends State<PumpingHistoryTableWidget> {
  int sortIndex = 0; // 0 -> new first
  String? _currentChildId;
  bool _showAll = false;
  static const int _initialRowLimit = 6;

  Map<String, String> _getPumpingInfoForRecord(EntityPumpingHistory record) {
    try {
      // Получаем общее количество молока
      final left = record.left ?? 0;
      final right = record.right ?? 0;
      final total = record.total ?? (left + right);
      
      // Определяем статус для конкретной записи сцеживания
      String status;
      String statusColor;
      if (total >= 100) { // 100+ мл = хорошее сцеживание
        status = 'Хорошее\nсцеживание';
        statusColor = 'green';
      } else if (total >= 50) { // 50-100 мл = среднее сцеживание
        status = 'Среднее\nсцеживание';
        statusColor = 'orange';
      } else { // < 50 мл = мало молока
        status = 'Мало молока';
        statusColor = 'red';
      }
      
      // Рассчитываем недостаток до нормы для конкретной записи
      int deficitMl = 0;
      if (total < 100) { // Если меньше 100 мл
        deficitMl = 100 - total;
      }
      
      return {
        'status': status,
        'statusColor': statusColor,
        'median': '${total} мл', // Количество молока в этой записи
        'normRange': '100-200мл', // Нормальный диапазон для сцеживания
        'toGain': deficitMl > 0 ? '${deficitMl} мл' : '0 мл', // Сколько нужно добрать до нормы для этой записи
      };
    } catch (e) {
      // Error getting pumping info for record
    }
    
    return {
      'status': '',
      'statusColor': 'transparent',
      'median': '',
      'normRange': '',
      'toGain': '',
    };
  }

  void _showPumpingDetailsDialog(BuildContext context, List<EntityPumpingHistory> allForDay, int startIndex, String dayLabel) {
    // Сохраняем ссылки на store и другие зависимости заранее
    final store = context.read<PumpingTableStore>();
    final deps = context.read<Dependencies>();
    final userStore = context.read<UserStore>();
    // Сохраняем родительский контекст страницы для навигации после закрытия диалога
    final parentContext = context;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        int index = startIndex;
        return StatefulBuilder(builder: (context, setState) {
          final rec = allForDay[index];
          
          // Получаем информацию о сцеживании для конкретной записи
          final pumpingInfo = _getPumpingInfoForRecord(rec);
          
          final left = rec.left ?? 0;
          final right = rec.right ?? 0;
          final total = rec.total ?? (left + right);
          
          // Определяем цвет статуса сцеживания
          Color pumpingStatusColor = Colors.transparent;
          if (pumpingInfo['statusColor'] == 'green') {
            pumpingStatusColor = const Color(0xFF4CAF50); // Зеленый
          } else if (pumpingInfo['statusColor'] == 'orange') {
            pumpingStatusColor = const Color(0xFFFF9800); // Оранжевый
          } else if (pumpingInfo['statusColor'] == 'red') {
            pumpingStatusColor = const Color(0xFFE53E3E); // Красный
          }
          
          final details = MeasurementDetails(
            title: t.feeding.pumping,
            currentWeek: dayLabel,
            previousWeek: '',
            selectedWeek: dayLabel,
            nextWeek: '',
            weight: '$total мл',
            weightStatus: pumpingInfo['status'] ?? '',
            weightStatusColor: pumpingStatusColor,
            medianWeight: pumpingInfo['median'] ?? '',
            normWeightRange: pumpingInfo['normRange'] ?? '',
            weightToGain: pumpingInfo['toGain'] ?? '',
            note: rec.notes,
            viewNormsLabel: 'Смотреть нормы сцеживания',
            onViewNormsTap: () {
              final router = GoRouter.of(parentContext);
              router.pushNamed(AppViews.serviceKnowlegde);
            },
            onClose: () => Navigator.of(dialogContext).pop(),
            onEdit: () {
              Navigator.of(dialogContext).pop();
              // Schedule navigation after dialog is closed
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (parentContext.mounted) {
                  parentContext.pushNamed(AppViews.addPumping, extra: rec).then((res) {
                    if (res == true && parentContext.mounted) {
                      final childId = userStore.selectedChild?.id;
                      store.loadPage(newFilters: [
                        SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                      ]);
                    }
                  });
                }
              });
            },
            onDelete: rec.id != null && rec.id!.isNotEmpty ? () async {
              // Debug: print the record details
              if (rec.id!.startsWith('temp_')) {
                // If it's a temporary ID, we can't delete it from server
                // Just remove it from local list
                if (dialogContext.mounted) {
                  store.listData.removeWhere((e) => e.id == rec.id);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Запись удалена')),
                  );
                }
                return;
              }
              
              // Сначала оптимистично удаляем запись из UI для мгновенного обновления
              if (dialogContext.mounted) {
                store.listData.removeWhere((e) => e.id == rec.id);
                Navigator.of(dialogContext).pop();
              }
              
              try {
                await deps.restClient.feed
                    .deleteFeedPumpingDeleteStats(
                        dto: FeedDeletePumpingDto(id: rec.id!));
                // Do not show SnackBar here to avoid context issues after dialog close
                
                // Refresh data from server in background to ensure consistency
                final childId = userStore.selectedChild?.id;
                store.loadPage(newFilters: [
                  SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                ]);
              } catch (error) {
                // В случае ошибки возвращаем запись обратно в список
                store.listData.add(rec);
                // Optionally report error elsewhere; avoid SnackBar here
              }
            } : null,
            onNoteEdit: () async {
              // Закрываем диалог и открываем экран редактирования заметки из контекста страницы
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!parentContext.mounted) return;
                parentContext.pushNamed(AppViews.addNote, extra: {
                'initialValue': rec.notes,
                'onSaved': (String value) async {
                  final childId = userStore.selectedChild?.id;
                  String? id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolvePumpingId(deps, childId, rec));
                  if (id == null) {
                    // Локально обновляем заметку, если id не удалось получить
                    final idx = store.listData.indexWhere((e) => e.id == rec.id);
                    if (idx >= 0) {
                      final old = store.listData[idx];
                      final updated = EntityPumpingHistory(
                        id: old.id,
                        time: old.time,
                        left: old.left,
                        right: old.right,
                        total: old.total,
                        notes: value,
                      );
                      store.listData[idx] = updated;
                      setState(() {});
                    }
                    return;
                  }

                  // Патчим заметку через /feed/pumping/notes
                  await deps.apiClient.patch('feed/pumping/notes', body: {
                    'id': id,
                    'notes': value,
                  });

                  // Обновляем локально и перезагружаем данные
                  final idx = store.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = store.listData[idx];
                    final updated = EntityPumpingHistory(
                      id: old.id,
                      time: old.time,
                      left: old.left,
                      right: old.right,
                      total: old.total,
                      notes: value,
                    );
                    store.listData[idx] = updated;
                    setState(() {});
                  }

                  store.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                  ]);
                },
              });
              });
            },
            onNoteDelete: rec.notes != null ? () async {
              // Разрешаем реальный UUID id, если пришел синтетический
              final childId = userStore.selectedChild?.id;
              final id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolvePumpingId(deps, childId, rec));
              
              if (id == null) {
                // Если не удалось найти ID на сервере, возможно это локальная запись
                // Очищаем заметку локально и показываем сообщение
                if (dialogContext.mounted) {
                  final idx = store.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = store.listData[idx];
                    final updated = EntityPumpingHistory(
                      id: old.id,
                      time: old.time,
                      left: old.left,
                      right: old.right,
                      total: old.total,
                      notes: null, // Очищаем заметку
                    );
                    store.listData.removeAt(idx);
                    store.listData.insert(idx, updated);
                    setState(() {});
                  }
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Заметка удалена')),
                  );
                }
                return;
              }

              deps.restClient.feed
                  .deleteFeedPumpingDeleteNotes(dto: FeedDeletePumpingDto(id: id))
                  .then((v) {
                if (dialogContext.mounted) {
                  // Оптимистично очищаем заметку в локальном списке для мгновенного обновления UI
                  final idx = store.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = store.listData[idx];
                    final updated = EntityPumpingHistory(
                      id: old.id,
                      time: old.time,
                      left: old.left,
                      right: old.right,
                      total: old.total,
                      notes: null, // Очищаем заметку
                    );
                    store.listData.removeAt(idx);
                    store.listData.insert(idx, updated);
                    setState(() {});
                  }
                  Navigator.of(dialogContext).pop();

                  // Фоново обновляем данные с сервера
                  final childId = userStore.selectedChild?.id;
                  store.loadPage(newFilters: [
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final childId = context.read<UserStore>().selectedChild?.id;
    
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      final store = context.read<PumpingTableStore>();
      
      if (store.listData.isEmpty) {
        // Используем только child_id фильтр, как в Sleep
        
        store.loadPage(newFilters: [
          SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
        ]);
      }
    }
  }

  DateTime _parse(String? s) {
    if (s == null) return DateTime.now();
    try {
      if (s.contains('T')) {
        final d = DateTime.parse(s);
        return d.isUtc ? d.toLocal() : d.toLocal();
      }
      if (s.contains(' ')) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(s).toLocal();
      }
      return DateFormat('yyyy-MM-dd').parse(s).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  bool _isUuid(String? id) {
    if (id == null) return false;
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    return uuidRegex.hasMatch(id);
  }

  Future<String?> _resolvePumpingId(Dependencies deps, String childId, EntityPumpingHistory rec) async {
    try {
      // Получаем данные с сервера для поиска реального ID
      final response = await deps.restClient.feed.getFeedPumpingGet(
        childId: childId,
      );
      
      // Ищем запись по времени и данным
      if (response.list != null) {
        for (final item in response.list!) {
          if (item.timeToEnd == rec.time && 
              item.leftFeeding == rec.left && 
              item.rightFeeding == rec.right) {
            return item.id;
          }
        }
      }
    } catch (e) {
    }
    return null;
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

    final store = context.watch<PumpingTableStore>();

    return Observer(builder: (_) {
      
      final Map<String, List<EntityPumpingHistory>> grouped = {};
      for (final e in store.listData) {
        final d = _parse(e.time);
        final k = DateFormat('yyyy-MM-dd').format(d);
        (grouped[k] ??= <EntityPumpingHistory>[]).add(e);
      }
      

      final mapDates = grouped.keys.toList()
        ..sort((a, b) {
          final da = DateTime.parse(a);
          final db = DateTime.parse(b);
          return sortIndex == 0 ? db.compareTo(da) : da.compareTo(db);
        });

      // Build sections with optional limit (like Bottle)
      int remaining = _showAll ? 1 << 30 : _initialRowLimit;
      final List<MapEntry<String, List<EntityPumpingHistory>>> sections = [];
      for (final k in mapDates) {
        if (remaining <= 0) break;
        final dayItems = grouped[k] ?? const <EntityPumpingHistory>[];
        final take = remaining < dayItems.length ? remaining : dayItems.length;
        sections.add(MapEntry(k, dayItems.take(take).toList()));
        remaining -= take;
      }

      // Determine if there are more records than currently shown
      final int shownCount = sections.fold<int>(0, (sum, e) => sum + e.value.length);
      final int totalCount = grouped.values.fold<int>(0, (sum, e) => sum + e.length);
      final bool canShowAll = !_showAll && shownCount < totalCount;

      // Notify parent if there is at least one item (used to show a banner after returning from Add)
      if ((store.listData).isNotEmpty) {
        widget.showSavedBanner?.call(true);
      }
      final bool canCollapse = _showAll;

      // Show empty state if no data
      if (store.listData.isEmpty && !store.isLoading) {
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
                  Expanded(flex: 2, child: Text(t.feeding.endTimeOfPumping, style: headerStyle, textAlign: TextAlign.left)),
                  Expanded(child: Text(t.feeding.leftMl, style: headerStyle, textAlign: TextAlign.center)),
                  Expanded(child: Text(t.feeding.rightMl, style: headerStyle, textAlign: TextAlign.center)),
                  Expanded(child: Text(t.feeding.totalMl, style: headerStyle, textAlign: TextAlign.center)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Нет записей сцеживания',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
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
                Expanded(flex: 2, child: Text(t.feeding.endTimeOfPumping, style: headerStyle, textAlign: TextAlign.left)),
                Expanded(child: Text(t.feeding.leftMl, style: headerStyle, textAlign: TextAlign.center)),
                Expanded(child: Text(t.feeding.rightMl, style: headerStyle, textAlign: TextAlign.center)),
                Expanded(child: Text(t.feeding.totalMl, style: headerStyle, textAlign: TextAlign.center)),
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
              final dateKey = sections[index].key;
              final input = DateFormat('yyyy-MM-dd').parse(dateKey);
              final String localeTag = t.$meta.locale.flutterLocale.toLanguageTag();
              final dateLabel = DateFormat('dd MMMM', localeTag).format(input);
              final fullDayItems = List<EntityPumpingHistory>.from(grouped[dateKey] ?? [])
                ..sort((a, b) => _parse(a.time).compareTo(_parse(b.time)));
              final dayItems = List<EntityPumpingHistory>.from(sections[index].value)
                ..sort((a, b) => _parse(a.time).compareTo(_parse(b.time)));

              int totalLeft = 0;
              int totalRight = 0;
              int totalAll = 0;
              final rows = <Widget>[];
              for (var i = 0; i < dayItems.length; i++) {
                final e = dayItems[i];
                final end = _parse(e.time);
                final left = e.left ?? 0;
                final right = e.right ?? 0;
                final all = e.total ?? (left + right);
                totalLeft += left;
                totalRight += right;
                totalAll += all;
                rows.add(InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showPumpingDetailsDialog(context, fullDayItems, i, dateLabel),
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
                          flex: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(DateFormat('HH:mm').format(end), style: cellStyle, textAlign: TextAlign.left),
                              const SizedBox(width: 6),
                              if ((e.notes != null && e.notes!.trim().isNotEmpty))
                                Icon(AppIcons.pencil, size: 14, color: theme.colorScheme.primary.withOpacity(0.6)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text('$left', style: cellStyle, textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('$right', style: cellStyle, textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('$all', style: cellStyle, textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ));
              }

              // Totals for the whole day (not only visible rows)
              final sumLeft = fullDayItems.fold<int>(0, (s, e) => s + (e.left ?? 0));
              final sumRight = fullDayItems.fold<int>(0, (s, e) => s + (e.right ?? 0));
              final sumAll = sumLeft + sumRight;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(dateLabel, style: dateStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(child: Text('$sumLeft', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        Expanded(child: Text('$sumRight', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                        Expanded(child: Text('$sumAll', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                  ...rows,
                ],
              );
            },
          ),
          if (canShowAll || canCollapse) ...[
            const SizedBox(height: 16),
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
          ],
        ],
      );
    });
  }
}


