import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';

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
                Expanded(child: Text('Left', style: headerStyle, textAlign: TextAlign.left)),
                Expanded(child: Text('Right', style: headerStyle, textAlign: TextAlign.center)),
                Expanded(child: Text('Total', style: headerStyle, textAlign: TextAlign.right)),
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
              
              rows.add(Container(
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
                          Text('Total', style: smallHint),
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
        ],
      ],
    );
    });
  }
}
