import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/feeding/bottle_table_store.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/core/api/models/feed_delete_food_dto.dart';
import 'package:mama/src/core/api/models/entity_food.dart';
import 'package:go_router/go_router.dart';

class BottleHistoryTableWidgetWrapper extends StatelessWidget {
  final void Function(bool showSavedBanner)? showSavedBanner;
  const BottleHistoryTableWidgetWrapper({super.key, this.showSavedBanner});

  @override
  Widget build(BuildContext context) {
    return BottleHistoryTableWidget(showSavedBanner: showSavedBanner);
  }
}

class BottleHistoryTableWidget extends StatefulWidget {
  final void Function(bool showSavedBanner)? showSavedBanner;
  const BottleHistoryTableWidget({super.key, this.showSavedBanner});

  @override
  State<BottleHistoryTableWidget> createState() => _BottleHistoryTableWidgetState();
}

class _BottleHistoryTableWidgetState extends State<BottleHistoryTableWidget> {
  int sortIndex = 0; // 0 -> new first
  String? _currentChildId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final childId = context.read<UserStore>().selectedChild?.id;
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      final store = context.read<BottleTableStore>();
      
      // Store теперь сам управляет загрузкой данных при смене ребенка
      // Просто активируем store если он неактивен
      store.activate();
    }
  }

  Map<String, String> _getBottleFeedingInfoForRecord(EntityFood record) {
    try {
      // Получаем общее количество кормления
      final chest = record.chest ?? 0;
      final mixture = record.mixture ?? 0;
      final total = chest + mixture;
      
      // Определяем статус для конкретной записи кормления
      String status;
      String statusColor;
      if (total >= 120) { // 120+ мл = хорошее кормление
        status = 'Хорошее кормление';
        statusColor = 'green';
      } else if (total >= 80) { // 80-120 мл = среднее кормление
        status = 'Среднее кормление';
        statusColor = 'orange';
      } else { // < 80 мл = мало еды
        status = 'Мало еды';
        statusColor = 'red';
      }
      
      // Рассчитываем недостаток до нормы для конкретной записи
      int deficitMl = 0;
      if (total < 120) { // Если меньше 120 мл
        deficitMl = 120 - total;
      }
      
      return {
        'status': status,
        'statusColor': statusColor,
        'median': '${total} мл', // Количество еды в этой записи
        'normRange': '120-200мл', // Нормальный диапазон для кормления
        'toGain': deficitMl > 0 ? '${deficitMl} мл' : '0 мл', // Сколько нужно добрать до нормы для этой записи
      };
    } catch (e) {
      debugPrint('Error getting bottle feeding info for record: $e');
    }
    
    return {
      'status': '',
      'statusColor': 'transparent',
      'median': '',
      'normRange': '',
      'toGain': '',
    };
  }

  void _showBottleDetailsDialog(BuildContext context, List<EntityFood> allForDay, int startIndex, String dayLabel) {
    // Сохраняем ссылки на store и другие зависимости заранее
    final store = context.read<BottleTableStore>();
    final deps = context.read<Dependencies>();
    final userStore = context.read<UserStore>();
    // Сохраняем родительский контекст страницы для корректной навигации после закрытия диалога
    final parentContext = context;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        int index = startIndex;
        return StatefulBuilder(builder: (context, setState) {
          final rec = allForDay[index];
          
          // Получаем информацию о кормлении для конкретной записи
          final feedingInfo = _getBottleFeedingInfoForRecord(rec);
          
          final chest = rec.chest ?? 0;
          final mixture = rec.mixture ?? 0;
          final total = chest + mixture;
          
          // Определяем цвет статуса кормления
          Color feedingStatusColor = Colors.transparent;
          if (feedingInfo['statusColor'] == 'green') {
            feedingStatusColor = const Color(0xFF4CAF50); // Зеленый
          } else if (feedingInfo['statusColor'] == 'orange') {
            feedingStatusColor = const Color(0xFFFF9800); // Оранжевый
          } else if (feedingInfo['statusColor'] == 'red') {
            feedingStatusColor = const Color(0xFFE53E3E); // Красный
          }
          
          final details = MeasurementDetails(
            title: t.feeding.bottle,
            currentWeek: dayLabel,
            previousWeek: '',
            selectedWeek: dayLabel,
            nextWeek: '',
            weight: '$total мл',
            weightStatus: feedingInfo['status'] ?? '',
            weightStatusColor: feedingStatusColor,
            medianWeight: feedingInfo['median'] ?? '',
            normWeightRange: feedingInfo['normRange'] ?? '',
            weightToGain: feedingInfo['toGain'] ?? '',
            note: rec.notes,
            viewNormsLabel: 'Смотреть нормы кормления',
            onClose: () => Navigator.of(dialogContext).pop(),
          onEdit: () {
            Navigator.of(dialogContext).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!parentContext.mounted) return;
              parentContext.pushNamed(AppViews.addBottle, extra: rec).then((res) {
                if (res == true && parentContext.mounted) {
                  final childId = userStore.selectedChild?.id;
                  store.loadPage(newFilters: [
                    SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                  ]);
                }
              });
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
                    .deleteFeedFoodDeleteStats(
                        dto: FeedDeleteFoodDto(id: rec.id!));
                
                // Show success message using the main context - проверяем mounted
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Запись удалена')),
                  );
                }
                
                // Refresh data from server in background to ensure consistency
                final childId = userStore.selectedChild?.id;
                store.loadPage(newFilters: [
                  SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
                ]);
              } catch (error) {
                // В случае ошибки возвращаем запись обратно в список
                store.listData.add(rec);
                
                // Show error message using the main context - проверяем mounted
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка при удалении записи: ${error.toString()}')),
                  );
                }
              }
            } : null,
          onNoteEdit: () async {
            // Закрываем диалог и открываем AddNote из контекста страницы
            Navigator.of(dialogContext).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!parentContext.mounted) return;
              parentContext.pushNamed(AppViews.addNote, extra: {
                  'initialValue': rec.notes,
                  'onSaved': (String value) async {
                    final childId = userStore.selectedChild?.id;
                    // Патчим заметку через /feed/food/notes
                    await deps.apiClient.patch('feed/food/notes', body: {
                      'id': rec.id,
                      'notes': value,
                    });
                    // Локально обновляем запись
                    final idx = store.listData.indexWhere((e) => e.id == rec.id);
                    if (idx >= 0) {
                      final old = store.listData[idx];
                      final updated = EntityFood(
                        id: old.id,
                        childId: old.childId,
                        timeToEnd: old.timeToEnd,
                        chest: old.chest,
                        mixture: old.mixture,
                        notes: value,
                      );
                      store.listData[idx] = updated;
                      setState(() {});
                    }
                    // Перезагружаем данные
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
              final id = _isUuid(rec.id) ? rec.id : (childId == null ? null : await _resolveFoodId(deps, childId, rec));
              
              if (id == null) {
                // Если не удалось найти ID на сервере, возможно это локальная запись
                // Очищаем заметку локально и показываем сообщение
                if (dialogContext.mounted) {
                  final idx = store.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = store.listData[idx];
                    final updated = EntityFood(
                      id: old.id,
                      childId: old.childId,
                      timeToEnd: old.timeToEnd,
                      chest: old.chest,
                      mixture: old.mixture,
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
                  .deleteFeedFoodDeleteNotes(dto: FeedDeleteFoodDto(id: id))
                  .then((v) {
                if (dialogContext.mounted) {
                  // Оптимистично очищаем заметку в локальном списке для мгновенного обновления UI
                  final idx = store.listData.indexWhere((e) => e.id == rec.id);
                  if (idx >= 0) {
                    final old = store.listData[idx];
                    final updated = EntityFood(
                      id: old.id,
                      childId: old.childId,
                      timeToEnd: old.timeToEnd,
                      chest: old.chest,
                      mixture: old.mixture,
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

  DateTime _parse(String? s) {
    if (s == null) return DateTime.now();
    try {
      if (s.contains('T')) return DateTime.parse(s);
      if (s.contains(' ')) return DateFormat('yyyy-MM-dd HH:mm:ss').parse(s);
      return DateFormat('yyyy-MM-dd').parse(s);
    } catch (_) {
      return DateTime.now();
    }
  }

  bool _isUuid(String? id) {
    if (id == null) return false;
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    return uuidRegex.hasMatch(id);
  }

  Future<String?> _resolveFoodId(Dependencies deps, String childId, EntityFood rec) async {
    try {
      // Получаем данные с сервера для поиска реального ID
      final response = await deps.restClient.feed.getFeedFoodGet(
        childId: childId,
      );
      
      // Ищем запись по времени и данным
      if (response.list != null) {
        for (final item in response.list!) {
          if (item.timeToEnd == rec.timeToEnd && 
              item.chest == rec.chest && 
              item.mixture == rec.mixture) {
            return item.id;
          }
        }
      }
    } catch (e) {
      debugPrint('Error resolving food ID: $e');
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
    final cellStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
    );

    final store = context.watch<BottleTableStore>();

    return Observer(builder: (_) {
      // Добавляем проверку на инициализацию store
      final listData = store.listData;
      if (listData == null) {
        return Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            const Center(child: CircularProgressIndicator()),
          ],
        );
      }
      
      final Map<String, List<EntityFood>> grouped = {};
      for (final e in listData) {  // Теперь безопасно
        final d = _parse(e.timeToEnd);
        final k = DateFormat('yyyy-MM-dd').format(d);
        (grouped[k] ??= <EntityFood>[]).add(e);
      }

      final mapDates = grouped.keys.toList()
        ..sort((a, b) {
          final da = DateTime.parse(a);
          final db = DateTime.parse(b);
          return sortIndex == 0 ? db.compareTo(da) : da.compareTo(db);
        });

      // Build sections with optional limit
      int remaining = store.showAll ? 1 << 30 : 6; // Используем 6 как лимит по умолчанию
      final List<MapEntry<String, List<EntityFood>>> sections = [];
      for (final k in mapDates) {
        if (remaining <= 0) break;
        final dayItems = grouped[k] ?? const <EntityFood>[];
        final take = remaining < dayItems.length ? remaining : dayItems.length;
        sections.add(MapEntry(k, dayItems.take(take).toList()));
        remaining -= take;
      }

      // Show empty state if no data
      if (listData.isEmpty && !store.isLoading) {
        return _buildEmptyState(theme, headerStyle);
      }

      return _buildDataTable(theme, headerStyle, dateStyle, cellStyle, sections, grouped, store);
    });
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildEmptyState(ThemeData theme, TextStyle? headerStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildTableHeader(headerStyle),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Нет записей кормления',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(TextStyle? headerStyle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('End time of feeding', style: headerStyle, textAlign: TextAlign.left)),
          Expanded(child: Text('Chest, ml', style: headerStyle, textAlign: TextAlign.center)),
          Expanded(child: Text('Mixture, ml', style: headerStyle, textAlign: TextAlign.center)),
          Expanded(child: Text('Total, ml', style: headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildDataTable(ThemeData theme, TextStyle? headerStyle, TextStyle? dateStyle, TextStyle? cellStyle, 
      List<MapEntry<String, List<EntityFood>>> sections, Map<String, List<EntityFood>> grouped, BottleTableStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildTableHeader(headerStyle),
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
            final dateLabel = DateFormat('dd MMMM').format(input);
            final fullDayItems = List<EntityFood>.from(grouped[dateKey] ?? [])
              ..sort((a, b) => _parse(a.timeToEnd).compareTo(_parse(b.timeToEnd)));
            final dayItems = List<EntityFood>.from(sections[index].value)
              ..sort((a, b) => _parse(a.timeToEnd).compareTo(_parse(b.timeToEnd)));

            int totalChest = 0;
            int totalMixture = 0;
            int totalAll = 0;
            final rows = <Widget>[];
            for (var i = 0; i < dayItems.length; i++) {
              final e = dayItems[i];
              final end = _parse(e.timeToEnd);
              final chest = e.chest ?? 0;
              final mixture = e.mixture ?? 0;
              final all = chest + mixture;
              totalChest += chest;
              totalMixture += mixture;
              totalAll += all;
              rows.add(InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _showBottleDetailsDialog(context, fullDayItems, i, dateLabel),
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
                        child: Text('$chest', style: cellStyle, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text('$mixture', style: cellStyle, textAlign: TextAlign.center),
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
            final sumChest = fullDayItems.fold<int>(0, (s, e) => s + (e.chest ?? 0));
            final sumMixture = fullDayItems.fold<int>(0, (s, e) => s + (e.mixture ?? 0));
            final sumAll = sumChest + sumMixture;

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
                      Expanded(child: Text('$sumChest', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      Expanded(child: Text('$sumMixture', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                      Expanded(child: Text('$sumAll', style: cellStyle?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                ...rows,
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        if (store.canShowAll || store.canCollapse) ...[
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                store.toggleShowAll();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  children: [
                    Text(
                      store.showAll ? 'Свернуть историю' : 'Вся история',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(store.showAll ? Icons.expand_less : Icons.expand_more, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}