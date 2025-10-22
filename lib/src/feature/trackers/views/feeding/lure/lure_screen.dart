import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/data/entity/history_of_feeding.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/api/export.dart';
import 'package:skit/skit.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';
import 'package:mama/src/feature/trackers/widgets/dialog_overlay.dart';
import 'package:mama/src/core/api/models/feed_delete_lure_dto.dart';
import 'package:uuid/uuid.dart';

class LureScreen extends StatefulWidget {
  const LureScreen({super.key});

  @override
  State<LureScreen> createState() => _LureScreenState();
}

class _LureScreenState extends State<LureScreen> {
  var isSwitch = false;
  String _sortOrder = 'new';
  int _emojiIndex = 0; // 0=all, 1=🙂, 2=🤢, 3=⚠
  int _reloadTick = 0;

  late final TemperatureInfoStore _infoStore;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('feed_lure_info') ?? true,
      onSet: (v) async => prefs.setBool('feed_lure_info', v),
    );
    _infoStore.getIsShowInfo().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return TrackerBody(
      isShowInfo: _infoStore.isShowInfo,
      setIsShowInfo: (v) {
        _infoStore.setIsShowInfo(v).then((_) => setState(() {}));
      },
      learnMoreWidgetText: t.trackers.findOutMoreTextLure,
      onPressLearnMore: () {
        context.pushNamed(AppViews.serviceKnowlegde);
      },
      bottomNavigatorBar: Padding(
        padding: const EdgeInsets.all(15),
        child: EditingButtons(
            addBtnText: t.feeding.addComplementaryFood,
            learnMoreTap: () {
              context.pushNamed(AppViews.serviceKnowlegde);
            },
            addButtonTap: () async {
              final res = await context.pushNamed(AppViews.addLure);
              if (res == true && mounted) {
                setState(() => _reloadTick++);
              }
            }),
      ),
      children: [
        SliverToBoxAdapter(child: 15.h),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomToggleButton(
                  items: [t.feeding.newS, t.feeding.old],
                  onTap: (index) {
                    setState(() {
                      _sortOrder = index == 0 ? 'new' : 'old';
                    });
                  },
                  btnWidth: 64,
                  btnHeight: 26),
              CustomToggleButton(
                  items: [t.feeding.all, '🙂', '🤢', '⚠'],
                  onTap: (index) {
                    setState(() {
                      _emojiIndex = index;
                    });
                  },
                  btnWidth: 40,
                  btnHeight: 26),
            ],
          ),
        ),
        SliverToBoxAdapter(child: 15.h),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                t.feeding.onlyWithAllergies,
                style: textTheme.labelLarge?.copyWith(
                    color: AppColors.greyBrighterColor,
                    fontWeight: FontWeight.w400),
              ),
              5.w,
              CupertinoSwitch(
                  value: isSwitch,
                  onChanged: (value) {
                    setState(() {
                      isSwitch = value;
                    });
                  })
            ],
          ),
        ),
        SliverToBoxAdapter(child: 15.h),
        SliverToBoxAdapter(
          child: _LureHistory(
            key: ValueKey(_reloadTick),
            sortOrder: _sortOrder,
            emojiIndex: _emojiIndex,
            onlyAllergies: isSwitch,
          ),
        ),
      ],
    );
  }
}

class _LureHistory extends StatefulWidget {
  final String sortOrder;
  final int emojiIndex; // 0=all, 1=🙂, 2=🤢, 3=⚠
  final bool onlyAllergies;
  const _LureHistory({super.key, required this.sortOrder, required this.emojiIndex, required this.onlyAllergies});

  @override
  State<_LureHistory> createState() => _LureHistoryState();
}

class _LureHistoryState extends State<_LureHistory> {
  bool _showAll = false; // show full history or first N rows
  static const int _initialRowLimit = 13; // show "Вся история" only if > 6 rows
  int _reloadTick = 0; // Для принудительного обновления данных

  Map<String, String> _getLureFeedingInfoForRecord(EntityLureHistory record) {
    try {
      // Получаем количество прикорма
      final gram = record.gram ?? 0;
      final reaction = (record.reaction ?? '').toLowerCase();
      
      // Определяем статус для конкретной записи прикорма
      String status;
      String statusColor;
      
      if (reaction == 'allergy') {
        status = 'Аллергическая реакция';
        statusColor = 'red';
      } else if (reaction == 'dislike') {
        status = 'Не понравилось';
        statusColor = 'orange';
      } else if (reaction == 'like') {
        if (gram >= 50) {
          status = 'Хороший прикорм';
          statusColor = 'green';
        } else {
          status = 'Мало съел';
          statusColor = 'orange';
        }
      } else {
        // Нет реакции или неизвестная реакция
        if (gram >= 50) {
          status = 'Нормальный прикорм';
          statusColor = 'green';
        } else if (gram >= 20) {
          status = 'Мало съел';
          statusColor = 'orange';
        } else {
          status = 'Очень мало';
          statusColor = 'red';
        }
      }
      
      // Рассчитываем рекомендации
      String recommendation = '';
      if (reaction == 'allergy') {
        recommendation = 'Исключить из рациона';
      } else if (reaction == 'dislike') {
        recommendation = 'Попробовать позже';
      } else if (gram < 30) {
        recommendation = 'Увеличить порцию';
      } else {
        recommendation = 'Продолжать вводить';
      }
      
      return {
        'status': status,
        'statusColor': statusColor,
        'gram': '${gram} г',
        'recommendation': recommendation,
        'reaction': reaction.isNotEmpty ? reaction : 'Нет реакции',
      };
    } catch (e) {
    }
    
    return {
      'status': '',
      'statusColor': 'transparent',
      'gram': '',
      'recommendation': '',
      'reaction': '',
    };
  }

  void _showLureDetailsDialog(BuildContext context, List<EntityLureHistory> allForDay, int startIndex, String dayLabel) {
    // Сохраняем ссылки на зависимости заранее
    final deps = context.read<Dependencies>();
    final userStore = context.read<UserStore>();
    // Сохраняем родительский контекст страницы для корректной навигации после закрытия диалога
    final parentContext = context;
    // Захватываем текущий инстанс GoRouter заранее, чтобы не искать его в postFrame
    final router = GoRouter.of(parentContext);
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        int index = startIndex;
        return StatefulBuilder(builder: (context, setState) {
          final rec = allForDay[index];
          
          // Получаем информацию о прикорме для конкретной записи
          final feedingInfo = _getLureFeedingInfoForRecord(rec);
          
          final gram = rec.gram ?? 0;
          final productName = rec.nameProduct ?? '';
          final reaction = rec.reaction ?? '';
          
          // Определяем цвет статуса прикорма
          Color feedingStatusColor = Colors.transparent;
          if (feedingInfo['statusColor'] == 'green') {
            feedingStatusColor = const Color(0xFF4CAF50); // Зеленый
          } else if (feedingInfo['statusColor'] == 'orange') {
            feedingStatusColor = const Color(0xFFFF9800); // Оранжевый
          } else if (feedingInfo['statusColor'] == 'red') {
            feedingStatusColor = const Color(0xFFE53E3E); // Красный
          }
          
          final details = MeasurementDetails(
            title: '${t.feeding.lure} - $productName',
            currentWeek: dayLabel,
            previousWeek: '',
            selectedWeek: dayLabel,
            nextWeek: '',
            weight: '${gram} г',
            weightStatus: feedingInfo['status'] ?? '',
            weightStatusColor: feedingStatusColor,
            medianWeight: feedingInfo['gram'] ?? '',
            normWeightRange: '30-100г', // Нормальный диапазон для прикорма
            weightToGain: feedingInfo['recommendation'] ?? '',
            note: rec.notes,
            viewNormsLabel: 'Смотреть нормы прикорма',
            onClose: () => Navigator.of(dialogContext).pop(),
            onEdit: () {
              final parentContext = context;
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                final res = await router.pushNamed(AppViews.addLure, extra: rec);
                if (res == true && parentContext.mounted) {
                  setState(() => _reloadTick++);
                }
              });
            },
            onDelete: () async {
              
              if (rec.id == null || rec.id!.isEmpty) {
                // Если нет ID, показываем сообщение
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Не удалось удалить запись: отсутствует ID')),
                  );
                }
                return;
              }
              
              // Сначала закрываем диалог
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              
              // Попробуем несколько подходов для удаления
              // Подход 1: Генерируем UUID на основе данных записи
              final uuidId = _generateUuidForRecord(rec);
              
              try {
                await deps.restClient.feed
                    .deleteFeedLureDeleteStats(
                        dto: FeedDeleteLureDto(id: uuidId));
                
                // Show success message using the main context
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Запись удалена успешно!')),
                  );
                  // Обновляем данные с небольшой задержкой
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      setState(() {
                        _reloadTick++;
                      });
                    }
                  });
                }
              } catch (error) {
                // Если не получилось с UUID, попробуем другой подход
                try {
                  // Попробуем использовать только время и продукт для генерации UUID
                  final simpleData = '${rec.time}_${rec.nameProduct}';
                  final simpleUuid = const Uuid().v5(Uuid.NAMESPACE_DNS, simpleData);
                  await deps.restClient.feed
                      .deleteFeedLureDeleteStats(
                          dto: FeedDeleteLureDto(id: simpleUuid));
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Запись удалена')),
                    );
                    setState(() {
                      _reloadTick++;
                    });
                  }
                } catch (error2) {
                  // Подход 3: Попробуем использовать только имя продукта для UUID
                  try {
                    final productData = rec.nameProduct ?? 'unknown_product';
                    final productUuid = const Uuid().v5(Uuid.NAMESPACE_DNS, productData);
                    await deps.restClient.feed
                        .deleteFeedLureDeleteStats(
                            dto: FeedDeleteLureDto(id: productUuid));
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Запись удалена (по имени продукта)')),
                      );
                      setState(() {
                        _reloadTick++;
                      });
                    }
                  } catch (error3) {
                    
                    // Подход 4: Попробуем использовать время для UUID
                    try {
                      final timeData = rec.time ?? 'unknown_time';
                      final timeUuid = const Uuid().v5(Uuid.NAMESPACE_DNS, timeData);
                      await deps.restClient.feed
                          .deleteFeedLureDeleteStats(
                              dto: FeedDeleteLureDto(id: timeUuid));
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Запись удалена (по времени)')),
                        );
                        setState(() {
                          _reloadTick++;
                        });
                      }
                    } catch (error4) {
                      
                      // Если все подходы не работают, показываем сообщение
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Не удалось удалить запись: Не поддерживает удаление записей прикорма'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  }
                }
              }
            },
            onNoteEdit: () async {
              Navigator.of(dialogContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!parentContext.mounted) return;
                router.pushNamed(AppViews.addNote, extra: {
                  'initialValue': rec.notes,
                  'onSaved': (String value) async {
                    if (rec.id == null || rec.id!.isEmpty) return;
                    await deps.apiClient.patch('feed/lure/notes', body: {
                      'id': rec.id,
                      'notes': value,
                    });
                    if (mounted) setState(() => _reloadTick++);
                  },
                });
              });
            },
            onNextWeekTap: index < allForDay.length - 1 ? () => setState(() => index++) : null,
            onPreviousWeekTap: index > 0 ? () => setState(() => index--) : null,
          );
          return MeasurementOverlay(details: details);
        });
      },
    );
  }

  bool _isUuid(String? id) {
    if (id == null) return false;
    final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    return uuidRegex.hasMatch(id);
  }

  String _generateUuidForRecord(EntityLureHistory rec) {
    // Создаем детерминированный UUID на основе данных записи
    final data = '${rec.time}_${rec.nameProduct}_${rec.gram}_${rec.reaction ?? 'no_reaction'}_${rec.notes ?? 'no_notes'}';
    final uuid = const Uuid();
    
    // Используем v5 UUID для детерминированной генерации
    return uuid.v5(Uuid.NAMESPACE_DNS, data);
  }

  Future<String?> _resolveLureId(Dependencies deps, String childId, EntityLureHistory rec) async {
    try {
      // Получаем данные с сервера для поиска реального ID
      final response = await deps.restClient.feed.getFeedLureHistory(
        childId: childId,
        pageSize: 200,
      );
      
      // Ищем запись по времени и данным
      if (response.list != null) {
        for (final total in response.list!) {
          if (total.pumpingLure != null) {
            for (final item in total.pumpingLure!) {
              // Сравниваем по всем полям для точного совпадения
              if (item.time == rec.time && 
                  item.nameProduct == rec.nameProduct && 
                  item.gram == rec.gram &&
                  item.reaction == rec.reaction &&
                  item.notes == rec.notes) {
                return item.id;
              }
            }
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
    final cellStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // "Time" + "Food" ближе друг к другу
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(
                        t.feeding.time,
                        style: headerStyle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.feeding.food,
                        style: headerStyle,
                      ),
                    ),
                  ],
                ),
              ),
              // Правый заголовок фиксированной ширины
              SizedBox(
                width: 80,
                child: Text(
                  t.feeding.quantityAndReaction,
                  style: headerStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        FutureBuilder<FeedResponseHistoryLure>(
          key: ValueKey(_reloadTick),
          future: Provider.of<Dependencies>(context, listen: false)
              .restClient
              .feed
              .getFeedLureHistory(
                childId:
                    Provider.of<UserStore>(context, listen: false).selectedChild?.id ?? '',
                pageSize: 200,
              ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox(height: 100);
            final list = snapshot.data!.list ?? [];
            final Map<String, List<EntityLureHistory>> grouped = {};
            for (final total in list) {
              final key = _normalizeDate(total.timeToEndTotal);
              for (final rec in total.pumpingLure ?? const <EntityLureHistory>[]) {
                // Генерируем временный ID для записей без ID
                final recordWithId = EntityLureHistory(
                  id: rec.id ?? 'temp_${rec.time}_${rec.nameProduct}_${rec.gram}',
                  gram: rec.gram,
                  nameProduct: rec.nameProduct,
                  notes: rec.notes,
                  reaction: rec.reaction,
                  time: rec.time,
                );
                (grouped[key] ??= <EntityLureHistory>[]).add(recordWithId);
              }
            }

            bool filter(EntityLureHistory e) {
              // Если включен фильтр "Only with allergies", показываем только аллергии
              if (widget.onlyAllergies) {
                final r = (e.reaction ?? '').toLowerCase();
                return r == 'allergy';
              }
              
              // Обычная фильтрация по emojiIndex
              if (widget.emojiIndex == 0) return true;
              final r = (e.reaction ?? '').toLowerCase();
              if (widget.emojiIndex == 1) return r == 'like';
              if (widget.emojiIndex == 2) return r == 'dislike';
              if (widget.emojiIndex == 3) return r == 'allergy';
              return true;
            }

            final keys = grouped.keys.toList()
              ..sort((a, b) => widget.sortOrder == 'new' ? b.compareTo(a) : a.compareTo(b));

            // Build limited sections similar to Bottle: cap total visible rows
            int remaining = _showAll ? 1 << 30 : _initialRowLimit;
            final List<MapEntry<String, List<EntityLureHistory>>> sections = [];
            for (final dayKey in keys) {
              if (remaining <= 0) break;
              final itemsFull = (grouped[dayKey] ?? const <EntityLureHistory>[])
                ..retainWhere(filter)
                ..sort((a, b) {
                  final timeA = a.time ?? '00:00';
                  final timeB = b.time ?? '00:00';
                  return widget.sortOrder == 'new' ? timeB.compareTo(timeA) : timeA.compareTo(timeB);
                });
              final take = remaining < itemsFull.length ? remaining : itemsFull.length;
              if (take > 0) {
                sections.add(MapEntry(dayKey, itemsFull.take(take).toList()));
                remaining -= take;
              }
            }

            // Compute total rows with current filters
            final int totalCount = keys.fold<int>(0, (sum, dayKey) {
              final itemsFull = (grouped[dayKey] ?? const <EntityLureHistory>[])
                ..retainWhere(filter);
              return sum + itemsFull.length;
            });

            final bool canShowAll = !_showAll && totalCount > _initialRowLimit && sections.isNotEmpty;
            final bool canCollapse = _showAll && totalCount > _initialRowLimit;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: sections.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                final dayKey = sections[index].key;
                final dateLabel = DateFormat('dd MMMM').format(DateTime.parse(dayKey));
                final items = List<EntityLureHistory>.from(sections[index].value);

                final rows = <Widget>[];
                String lastTime = '';
                for (int i = 0; i < items.length; i++) {
                  final d = items[i];
                  final currentTime = (d.time ?? '').trim();
                  rows.add(InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showLureDetailsDialog(context, items, i, dateLabel),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      margin: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 56,
                                  child: Text(
                                    currentTime.isNotEmpty && currentTime != lastTime ? currentTime : '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: cellStyle?.copyWith(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(d.nameProduct ?? '', style: cellStyle?.copyWith(fontSize: 14))),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${d.gram ?? 0} г', style: cellStyle?.copyWith(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(_emojiForReaction(d.reaction), style: cellStyle?.copyWith(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                  lastTime = currentTime;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(dateLabel, style: dateStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(width: 6),
                                if ((items.any((e) => (e.notes != null && e.notes!.trim().isNotEmpty))))
                                  Icon(AppIcons.pencil, size: 14, color: theme.textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...rows,
                  ],
                );
              },
            ),
            if (canShowAll || canCollapse) ...[
              const SizedBox(height: 8),
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
          },
        ),
        const SizedBox(height: 0),
      ],
    );
  }
  List<HistoryOfFeeding> _filtered() {
    List<HistoryOfFeeding> items = widget.sortOrder == 'new' ? historyOfLure : historyOfLure.reversed.toList();
    if (widget.onlyAllergies) {
      items = items
          .map((d) => HistoryOfFeeding(
                firstColumnText: d.firstColumnText,
                secondColumnText: d.secondColumnText,
                thirdColumnText: d.thirdColumnText,
                fourthColumnText: d.fourthColumnText,
                detailColumnText: d.detailColumnText
                    .where((r) => r.detailThirdColumnText.contains('⚠'))
                    .toList(),
              ))
          .where((d) => d.detailColumnText.isNotEmpty)
          .toList();
    }

    // Emoji filter
    if (widget.emojiIndex > 0) {
      final emoji = widget.emojiIndex == 1
          ? '🙂'
          : widget.emojiIndex == 2
              ? '🤢'
              : '⚠';
      items = items
          .map((d) => HistoryOfFeeding(
                firstColumnText: d.firstColumnText,
                secondColumnText: d.secondColumnText,
                thirdColumnText: d.thirdColumnText,
                fourthColumnText: d.fourthColumnText,
                detailColumnText: d.detailColumnText
                    .where((r) => r.detailThirdColumnText.contains(emoji))
                    .toList(),
              ))
          .where((d) => d.detailColumnText.isNotEmpty)
          .toList();
    }

    return items;
  }
}

String _emojiForReaction(String? reaction) {
  switch ((reaction ?? '').toLowerCase()) {
    case 'like':
      return '🙂';
    case 'dislike':
      return '🤢';
    case 'allergy':
      return '⚠';
    default:
      return '';
  }
}

String _normalizeDate(String? date) {
  if (date == null) return DateFormat('yyyy-MM-dd').format(DateTime.now());
  try {
    // Handle Russian date format like "30 сентября", "22 сентября" FIRST
    if (date.contains('сентября')) {
      final day = int.tryParse(date.split(' ')[0]) ?? 1;
      final currentYear = DateTime.now().year;
      final d = DateTime(currentYear, 9, day); // September = 9
      return DateFormat('yyyy-MM-dd').format(d);
    }
    
    if (date.contains('T')) {
      final d = DateTime.parse(date).toLocal();
      return DateFormat('yyyy-MM-dd').format(d);
    }
    if (date.contains(' ')) {
      final hasMillis = date.contains('.');
      final fmt = hasMillis
          ? DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
          : DateFormat('yyyy-MM-dd HH:mm:ss');
      final d = fmt.parse(date, true).toLocal();
      return DateFormat('yyyy-MM-dd').format(d);
    }
    final d = DateFormat('yyyy-MM-dd').parse(date, true).toLocal();
    return DateFormat('yyyy-MM-dd').format(d);
  } catch (_) {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
