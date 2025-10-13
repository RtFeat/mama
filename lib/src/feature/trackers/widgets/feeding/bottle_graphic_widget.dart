import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/data/entity/pumping_data.dart';
import 'package:mobx/mobx.dart';

class BottleGraphicWidget extends StatefulWidget {
  const BottleGraphicWidget({super.key});

  @override
  State<BottleGraphicWidget> createState() => _BottleGraphicWidgetState();
}

class _BottleGraphicWidgetState extends State<BottleGraphicWidget> {
  int _weekOffset = 0; // 0 - текущая неделя, -1 - прошлая, +1 - следующая
  String? _currentChildId;
  ReactionDisposer? _childIdReaction;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final userStore = context.read<UserStore>();
        _currentChildId = userStore.selectedChild?.id;
      }
    });
    _setupChildIdReaction();
  }

  void _setupChildIdReaction() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final userStore = context.read<UserStore>();
      _childIdReaction = reaction(
        (_) => userStore.selectedChild?.id,
        (String? newChildId) {
          if (mounted && newChildId != _currentChildId) {
            setState(() {
              _currentChildId = newChildId;
            });
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _childIdReaction?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<UserStore>();
    final restClient = context.read<Dependencies>().restClient;

    return FutureBuilder<List<GraphicData>>(
      key: ValueKey('${_currentChildId}_$_weekOffset'),
      future: _loadChartData(restClient, _currentChildId, _weekOffset),
      builder: (context, snapshot) {
        final list = snapshot.data ?? const <GraphicData>[];
        final maxVal = list.fold<int>(0, (m, e) => e.general > m ? e.general : m);
        final step = 100;
        final roundedMax = ((maxVal + step - 1) ~/ step) * step;
        final safeMax = roundedMax > 0 ? roundedMax : step;

        final (start, end) = _currentWeekRange(_weekOffset);
        final avg = list.isEmpty
            ? 0
            : (list.map((e) => e.general).reduce((a, b) => a + b) / list.length)
                .round();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GraphicWidget(
            listOfData: list,
            topColumnText: t.feeding.breast,
            bottomColumnText: t.feeding.mixture,
            minimum: 0,
            maximum: safeMax.toDouble(),
            interval: step.toDouble(),
            rangeLabel:
                '${DateFormat('d MMMM').format(start)} - ${DateFormat('d MMMM').format(end)}',
            averageLabel: '$avg мл в среднем в день',
            onPrev: () => setState(() => _weekOffset--),
            onNext: () => setState(() => _weekOffset++),
          ),
        );
      },
    );
  }

  Future<List<GraphicData>> _loadChartData(
      RestClient restClient, String? childId, int weekOffset) async {
    if (childId == null) return _emptyWeek();
    try {
      final resp =
          await restClient.feed.getFeedFoodHistory(childId: childId, pageSize: 200);

      final Map<String, _Totals> byDate = {};
      for (final total in resp.list ?? []) {
        final dateKey = _normalizeDateKey(total.timeToEndTotal);
        final left = total.totalChest ?? 0;
        final right = total.totalMixture ?? 0;
        final all = total.totalTotal ?? (left + right);
        byDate[dateKey] = _Totals(left: left, right: right, total: all);
      }

      final (start, _) = _currentWeekRange(weekOffset);
      final DateFormat keyFmt = DateFormat('yyyy-MM-dd');
      final DateFormat labelFmt = DateFormat('E d');
      final List<GraphicData> result = [];
      for (int i = 0; i < 7; i++) {
        final d = start.add(Duration(days: i));
        final key = keyFmt.format(d);
        final totals = byDate[key] ?? const _Totals();
        result.add(GraphicData(
          weekDay: labelFmt.format(d),
          general: totals.total,
          top: totals.left,
          bottom: totals.right,
        ));
      }
      return result;
    } catch (_) {
      return _emptyWeek();
    }
  }

  (DateTime, DateTime) _currentWeekRange(int offset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final int weekday = today.weekday;
    final start = today.subtract(Duration(days: weekday - 1)).add(Duration(days: offset * 7));
    final end = start.add(const Duration(days: 6));
    return (start, end);
  }

  List<GraphicData> _emptyWeek() {
    final (start, _) = _currentWeekRange(0);
    final DateFormat labelFmt = DateFormat('E d');
    final List<GraphicData> list = [];
    for (int i = 0; i < 7; i++) {
      final d = start.add(Duration(days: i));
      list.add(GraphicData(weekDay: labelFmt.format(d), general: 0, top: 0, bottom: 0));
    }
    return list;
  }

  String _normalizeDateKey(String? date) {
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
        final d = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date, true).toLocal();
        return DateFormat('yyyy-MM-dd').format(d);
      }
      final d = DateFormat('yyyy-MM-dd').parse(date, true).toLocal();
      return DateFormat('yyyy-MM-dd').format(d);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }
}

class _Totals {
  final int left;
  final int right;
  final int total;
  const _Totals({this.left = 0, this.right = 0, this.total = 0});
}

