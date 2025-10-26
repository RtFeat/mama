import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:mama/src/core/api/models/feed_delete_chest_dto.dart';
import 'package:mama/src/feature/trackers/state/add_feeding.dart';
import 'package:mama/src/feature/notes/state/add_note.dart';
import 'package:mama/src/feature/trackers/widgets/edit_feeding_breast_manually.dart';
import 'package:go_router/go_router.dart';

class BreastFeedingHistoryTableWidget extends StatefulWidget {
  const BreastFeedingHistoryTableWidget({super.key});

  @override
  State<BreastFeedingHistoryTableWidget> createState() => _BreastFeedingHistoryTableWidgetState();
}

class _BreastFeedingHistoryTableWidgetState extends State<BreastFeedingHistoryTableWidget> {
  int sortIndex = 0; // 0 -> new first

  String? _currentChildId;

  @override
  void initState() {
    super.initState();
    // Активируем store при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<BreastFeedingTableStore>();
      store.activate();
    });
  }

  @override
  void dispose() {
    // Деактивируем store при dispose
    try {
      final store = context.read<BreastFeedingTableStore>();
      store.deactivate();
    } catch (e) {
      // Игнорируем ошибки при деактивации
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final childId = context.read<UserStore>().selectedChild?.id;
    if (childId != null && childId != _currentChildId) {
      _currentChildId = childId;
      final store = context.read<BreastFeedingTableStore>();
      if (store.listData.isEmpty) {
        store.loadPage(newFilters: [
          SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
        ]);
      }
    }
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

  String _minutesToHhMm(int minutesTotal) {
    final hours = minutesTotal ~/ 60;
    final minutes = minutesTotal % 60;
    if (hours == 0) return '${minutes}${t.trackers.min}';
    return '${hours}ч ${minutes}${t.trackers.min}';
  }

  void _showBreastFeedingDetailsDialog(BuildContext context, List<EntityFeeding> allForDay, int startIndex, String dayLabel) {
    // Сохраняем ссылки на store и другие зависимости заранее
    final store = context.read<BreastFeedingTableStore>();
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
          
          final leftMinutes = rec.leftFeeding ?? 0;
          final rightMinutes = rec.rightFeeding ?? 0;
          final allMinutes = rec.allFeeding ?? 0;
          
          // Определяем цвет статуса кормления
          Color feedingStatusColor = const Color(0xFF4CAF50); // Зеленый по умолчанию
          String status = 'Нормальное кормление';
          
          if (allMinutes < 5) {
            status = 'Короткое кормление';
            feedingStatusColor = const Color(0xFFFF9800); // Оранжевый
          } else if (allMinutes > 60) {
            status = 'Длительное кормление';
            feedingStatusColor = const Color(0xFF4CAF50); // Зеленый
          }
          
          final details = MeasurementDetails(
            title: t.feeding.breast,
            currentWeek: dayLabel,
            previousWeek: '',
            selectedWeek: dayLabel,
            nextWeek: '',
            weight: '${allMinutes}м',
            weightStatus: status,
            weightStatusColor: feedingStatusColor,
            medianWeight: 'Левая: ${leftMinutes}м,\nПравая: ${rightMinutes}м',
            normWeightRange: '5-60 минут',
            weightToGain: allMinutes < 5 ? 'Увеличить время\nкормления' : 'Кормление в\n норме',
            note: rec.notes,
            viewNormsLabel: 'Смотреть нормы кормления',
            onClose: () => Navigator.of(dialogContext).pop(),
            onEdit: () {
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                
                // Переходим к редактированию записи
                Navigator.of(parentContext).push(
                  MaterialPageRoute(
                    builder: (context) => EditFeedingBreastManually(
                      existingRecord: rec,
                      store: store,
                    ),
                  ),
                );
              });
            },
            onDelete: () async {
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                try {
                  if (rec.id != null && rec.id!.isNotEmpty) {
                    await deps.restClient.feed.deleteFeedChestDeleteStats(
                      dto: FeedDeleteChestDto(id: rec.id!),
                    );
                    // Обновляем данные в таблице
                    await store.refreshForChild(store.childId);
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Запись кормления грудью удалена')),
                      );
                    }
                  } else {
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('ID записи не найден')),
                      );
                    }
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Ошибка удаления записи: $e')),
                    );
                  }
                }
              }
            },
            onNoteEdit: rec.id != null && rec.id!.isNotEmpty ? () async {
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                
                // Создаем экземпляр AddFeeding для работы с заметками
                final addFeeding = AddFeeding(
                  childId: userStore.selectedChild!.id!,
                  restClient: deps.restClient,
                  noteStore: context.read<AddNoteStore>(),
                );
                
                // Переходим к редактированию заметки
                final router = GoRouter.of(parentContext);
                router.pushNamed(AppViews.addNote, extra: {
                  'initialValue': rec.notes ?? '',
                  'onSaved': (String value) async {
                    try {
                      await addFeeding.updateFeedingNotes(rec.id!, value);
                      // Обновляем данные в таблице
                      await store.refreshForChild(store.childId);
                    } catch (e) {
                      if (parentContext.mounted) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(content: Text('Ошибка обновления заметки: $e')),
                        );
                      }
                    }
                  },
                });
              });
            } : null,
            onNoteDelete: rec.notes != null && rec.notes!.isNotEmpty && rec.id != null && rec.id!.isNotEmpty ? () async {
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                
                try {
                  // Создаем экземпляр AddFeeding для работы с заметками
                  final addFeeding = AddFeeding(
                    childId: userStore.selectedChild!.id!,
                    restClient: deps.restClient,
                    noteStore: context.read<AddNoteStore>(),
                  );
                  
                  await addFeeding.deleteFeedingNotes(rec.id!);
                  // Обновляем данные в таблице
                  await store.refreshForChild(store.childId);
                } catch (e) {
                  // Показываем уведомление об ошибке только если контекст еще активен
                  if (parentContext.mounted) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(content: Text('Ошибка удаления заметки: $e')),
                    );
                  }
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

    final store = context.read<BreastFeedingTableStore>();

    return Observer(builder: (_) {

      final Map<String, List<EntityFeeding>> grouped = {};
      for (final e in store.listData) {
        final d = _parse(e.timeToEnd);
        final k = DateFormat('yyyy-MM-dd').format(d);
        (grouped[k] ??= <EntityFeeding>[]).add(e);
      }

      final mapDates = grouped.keys.toList()
        ..sort((a, b) {
          final da = DateTime.parse(a);
          final db = DateTime.parse(b);
          return sortIndex == 0 ? db.compareTo(da) : da.compareTo(db);
        });

      // Ограничиваем количество отображаемых дат в зависимости от showAll
      final datesToShow = store.showAll ? mapDates : mapDates.take(5).toList();

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
                Expanded(child: Text(t.feeding.left, style: headerStyle, textAlign: TextAlign.left)),
                Expanded(child: Text(t.feeding.right, style: headerStyle, textAlign: TextAlign.center)),
                Expanded(child: Text(t.feeding.total, style: headerStyle, textAlign: TextAlign.right)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
          shrinkWrap: true,
          itemCount: datesToShow.length,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final inputFormat = DateFormat('yyyy-MM-dd');
            final input = inputFormat.parse(datesToShow[index]);
            final dateLabel = DateFormat('dd MMMM').format(input);
            final dayItems = List<EntityFeeding>.from(grouped[datesToShow[index]] ?? [])
              ..sort((a, b) => _parse(a.timeToEnd).compareTo(_parse(b.timeToEnd)));

            int totalLeftMinutes = 0;
            int totalRightMinutes = 0;
            int totalAllMinutes = 0;
            final rows = <Widget>[];
            for (var i = 0; i < dayItems.length; i++) {
              final e = dayItems[i];
              final end = _parse(e.timeToEnd);
              final leftMinutes = e.leftFeeding ?? 0;
              final rightMinutes = e.rightFeeding ?? 0;
              final allMinutes = e.allFeeding ?? 0;
              
              totalLeftMinutes += leftMinutes;
              totalRightMinutes += rightMinutes;
              totalAllMinutes += allMinutes;
              
              rows.add(InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _showBreastFeedingDetailsDialog(context, dayItems, i, dateLabel),
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${leftMinutes}м',
                                style: cellStyle,
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(width: 6),
                              if ((e.notes != null && e.notes!.trim().isNotEmpty))
                                Icon(AppIcons.pencil, size: 14, color: theme.colorScheme.primary.withOpacity(0.6)),
                            ],
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
                        '${rightMinutes}м',
                        style: cellStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _minutesToHhMm(allMinutes),
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
                          Text(t.feeding.total, style: smallHint),
                          const SizedBox(width: 8),
                          Text(
                            _minutesToHhMm(totalAllMinutes),
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
        if (store.canShowAll || store.canCollapse) ...[
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  store.toggleShowAll();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  children: [
                    Text(
                      store.showAll ? 'Свернуть историю' : t.feeding.wholeStory,
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
        ],
        const SizedBox(height: 10), // Добавляем дополнительное пространство снизу
      ],
    );
    });
  }
}
