import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/data/entity/pumping_data.dart';

class PumpingGraphicWidget extends StatefulWidget {
  const PumpingGraphicWidget({super.key});

  @override
  State<PumpingGraphicWidget> createState() => _PumpingGraphicWidgetState();
}

class _PumpingGraphicWidgetState extends State<PumpingGraphicWidget> {
  int _weekOffset = 0; // 0 - текущая неделя, -1 - прошлая, +1 - следующая

  @override
  Widget build(BuildContext context) {
    final userStore = context.read<UserStore>();
    final restClient = context.read<Dependencies>().restClient;

    return FutureBuilder<List<GraphicData>>(
      future: _loadChartData(restClient, userStore.selectedChild?.id, _weekOffset),
      builder: (context, snapshot) {
        final List<GraphicData> list = snapshot.data ?? const <GraphicData>[];
        // Подберем максимум с округлением вверх к шагу 50
        final maxVal = list.fold<int>(0, (m, e) => e.general > m ? e.general : m);
        final int step = 50;
        final int roundedMax = ((maxVal + step - 1) ~/ step) * step;
        final int safeMax = roundedMax > 0 ? roundedMax : 50;

        final (start, end) = _currentWeekRange(_weekOffset);
        final avg = list.isEmpty
            ? 0
            : (list.map((e) => e.general).reduce((a, b) => a + b) / list.length)
                .round();
        final rangeLabel = '${DateFormat('d MMMM').format(start)} - ${DateFormat('d MMMM').format(end)}';
        final averageLabel = '$avg мл в среднем в день';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GraphicWidget(
            listOfData: list,
            topColumnText: t.feeding.l,
            bottomColumnText: t.feeding.r,
            minimum: 0,
            maximum: safeMax.toDouble(),
            interval: step.toDouble(),
            rangeLabel: rangeLabel,
            averageLabel: averageLabel,
            onPrev: () => setState(() => _weekOffset--),
            onNext: () => setState(() => _weekOffset++),
          ),
        );
      },
    );
  }

  Future<List<GraphicData>> _loadChartData(RestClient restClient, String? childId, int weekOffset) async {
    if (childId == null) return _emptyWeek();
    try {
      final (start, _) = _currentWeekRange(weekOffset);
      // История возвращает сгруппированные данные по датам, отфильтруем по неделе
      final resp = await restClient.feed.getFeedPumpingHistory(childId: childId, pageSize: 200);
      // Сформируем карту дата->суммы
      final Map<String, _Totals> byDate = {};
      for (final total in resp.list ?? []) {
        final dateKey = _normalizeDateKey(total.timeToEnd);
        final left = total.totalLeft ?? 0;
        final right = total.totalRight ?? 0;
        final all = total.totalTotal ?? (left + right);
        byDate[dateKey] = _Totals(left: left, right: right, total: all);
      }

      // 7 последовательных дней выбранной недели
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
    final int weekday = today.weekday; // 1..7, где 1 - понедельник
    final startOfWeek =
        today.subtract(Duration(days: weekday - 1)).add(Duration(days: offset * 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return (startOfWeek, endOfWeek);
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
