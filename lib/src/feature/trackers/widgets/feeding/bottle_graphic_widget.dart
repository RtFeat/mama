import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:mama/src/feature/trackers/data/entity/pumping_data.dart';
import 'package:mobx/mobx.dart';

class BottleGraphicWidget extends StatefulWidget {
  final int? reloadTick;
  final VoidCallback? onRefreshRequested;
  const BottleGraphicWidget({super.key, this.reloadTick, this.onRefreshRequested});

  @override
  State<BottleGraphicWidget> createState() => _BottleGraphicWidgetState();
}

class _BottleGraphicWidgetState extends State<BottleGraphicWidget> {
  int _weekOffset = 0; // 0 - текущая неделя, -1 - прошлая, +1 - следующая
  String? _currentChildId;
  ReactionDisposer? _childIdReaction;
  int _lastReloadTick = 0;
  Future<List<GraphicData>>? _cachedData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final userStore = context.read<UserStore>();
        _currentChildId = userStore.selectedChild?.id;
        // Если reloadTick больше 0, это означает что мы вернулись после добавления записи
        if (widget.reloadTick != null && widget.reloadTick! > 0) {
          _lastReloadTick = widget.reloadTick!;
          _forceRefresh();
        }
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
              _cachedData = null; // Очищаем кэш при смене ребенка
            });
          }
        },
      );
    });
  }

  @override
  void didUpdateWidget(BottleGraphicWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если изменился reloadTick, принудительно обновляем график
    if (widget.reloadTick != null && widget.reloadTick != _lastReloadTick) {
      _lastReloadTick = widget.reloadTick!;
      // Принудительно обновляем график
      _forceRefresh();
    }
  }

  void _forceRefresh() {
    // Очищаем кэш для принудительного обновления
    _cachedData = null;
    // Принудительно перестраиваем FutureBuilder
    setState(() {});
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
      key: ValueKey('${_currentChildId}_${_weekOffset}_${widget.reloadTick ?? 0}'),
      future: _cachedData ?? _loadChartData(restClient, _currentChildId, _weekOffset),
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
            onPrev: () {
              setState(() {
                _weekOffset--;
                _cachedData = null; // Очищаем кэш при смене недели
              });
            },
            onNext: () {
              setState(() {
                _weekOffset++;
                _cachedData = null; // Очищаем кэш при смене недели
              });
            },
          ),
        );
      },
    );
  }

  Future<List<GraphicData>> _loadChartData(
      RestClient restClient, String? childId, int weekOffset) async {
    if (childId == null) return _emptyWeek();
    
    // Создаем Future и сохраняем его в кэш
    final future = _loadChartDataInternal(restClient, childId, weekOffset);
    _cachedData = future;
    return future;
  }

  Future<List<GraphicData>> _loadChartDataInternal(
      RestClient restClient, String? childId, int weekOffset) async {
    if (childId == null) return _emptyWeek();
    try {
      // Выполняем до 5 попыток для текущей недели: сервер может кэшировать агрегированные данные
      // Повторим запрос для текущей недели, чтобы добиться мгновенного обновления
      Map<String, _Totals> byDate = {};
      int maxAttempts = weekOffset == 0 ? 5 : 1; // Больше попыток только для текущей недели
      
      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final resp = await restClient.feed.getFeedFoodHistory(childId: childId, pageSize: 200);
        byDate.clear();
        for (final total in resp.list ?? []) {
          final dateKey = _normalizeDateKey(total.timeToEnd);
          final left = total.totalChest ?? 0;
          final right = total.totalMixture ?? 0;
          final all = total.totalTotal ?? (left + right);
          byDate[dateKey] = _Totals(left: left, right: right, total: all);
        }
        
        // Если не текущая неделя — прерываемся после первой попытки
        if (weekOffset != 0) break;
        
        // Для текущей недели проверяем наличие сегодняшних данных
        final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final hasToday = byDate.containsKey(todayKey);
        
        // Если данные есть или это последняя попытка - прерываемся
        if (hasToday || attempt == maxAttempts - 1) break;
        
        // Прогрессивная задержка: 500ms, 1000ms, 1500ms, 2000ms
        await Future.delayed(Duration(milliseconds: 500 + (attempt * 500)));
      }
      
      // Если после всех попыток данные все еще не актуальны, попробуем альтернативный подход
      if (weekOffset == 0 && !byDate.containsKey(DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
        byDate = await _loadDataFromIndividualRecords(restClient, childId);
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
    if (date == null) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    try {
      String result;
      if (date.contains('T')) {
        final d = DateTime.parse(date).toLocal();
        result = DateFormat('yyyy-MM-dd').format(d);
      } else if (date.contains(' ')) {
        final d = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date, true).toLocal();
        result = DateFormat('yyyy-MM-dd').format(d);
      } else {
        final d = DateFormat('yyyy-MM-dd').parse(date, true).toLocal();
        result = DateFormat('yyyy-MM-dd').format(d);
      }
      return result;
    } catch (e) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  // Альтернативный метод: агрегация данных из отдельных записей
  Future<Map<String, _Totals>> _loadDataFromIndividualRecords(
      RestClient restClient, String childId) async {
    try {
      final response = await restClient.feed.getFeedFoodGet(childId: childId);
      final Map<String, _Totals> byDate = {};
      
      for (final record in response.list ?? []) {
        final dateKey = _normalizeDateKey(record.timeToEnd);
        final chest = record.chest?.toInt() ?? 0;
        final mixture = record.mixture?.toInt() ?? 0;
        final total = chest + mixture;
        
        if (byDate.containsKey(dateKey)) {
          final existing = byDate[dateKey]!;
          byDate[dateKey] = _Totals(
            left: (existing.left + chest).toInt(),
            right: (existing.right + mixture).toInt(),
            total: (existing.total + total).toInt(),
          );
        } else {
          byDate[dateKey] = _Totals(left: chest, right: mixture, total: total);
        }
      }
      
      return byDate;
    } catch (e) {
      return {};
    }
  }
}

class _Totals {
  final int left;
  final int right;
  final int total;
  const _Totals({this.left = 0, this.right = 0, this.total = 0});
}

