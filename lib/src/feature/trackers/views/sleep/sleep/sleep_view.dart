import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep_table_store.dart';
import 'package:mama/src/feature/trackers/widgets/switch_container.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/feature/trackers/widgets/date_range_selector.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/week_table.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/sleep_history_table.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';

class SleepScreen extends StatefulWidget {
  final bool isActiveTab;
  const SleepScreen({super.key, this.isActiveTab = true});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  String? _lastChildId;
  late final TemperatureInfoStore _infoStore;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final int weekday = now.weekday; // 1..7 (Mon..Sun)
    startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('sleep_info') ?? true,
      onSet: (v) async => prefs.setBool('sleep_info', v),
    );
    _infoStore.getIsShowInfo().then((_) => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userStore = context.read<UserStore>();
    final childId = userStore.selectedChild?.id;
    if (childId != null && childId.isNotEmpty && childId != _lastChildId) {
      _lastChildId = childId;
      final sleepTableStore = context.read<SleepTableStore>();
      sleepTableStore.loadPage(newFilters: [
        SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
        isShowInfo: _infoStore.isShowInfo,
        setIsShowInfo: (v) {
          _infoStore.setIsShowInfo(v).then((_) => setState(() {}));
        },
        learnMoreWidgetText: t.trackers.findOutMoreTextSleep,
        onPressLearnMore: () {
          context.pushNamed(AppViews.serviceKnowlegde);
        },
        children: [
          const SliverToBoxAdapter(child: SleepWidget()),
          SliverToBoxAdapter(
            child: Builder(builder: (context) {
              final sleepStore = context.watch<SleepStore>();
              final hideWeek = sleepStore.showEditMenu; // прячем неделю, когда открыт таймер/редактор
              if (hideWeek) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  const SizedBox(height: 8),
                  DateRangeSelectorWidget(
                  startDate: startOfWeek,
                  endDate: endOfWeek,
                  onLeftTap: () async {
                    setState(() {
                      startOfWeek =
                          startOfWeek.subtract(const Duration(days: 7));
                      endOfWeek = startOfWeek.add(const Duration(days: 6));
                    });
                    // Обновляем данные при смене недели
                    final sleepTableStore = context.read<SleepTableStore>();
                    final userStore = context.read<UserStore>();
                    final childId = userStore.selectedChild?.id ?? '';
                    
                    sleepTableStore.loadPage(newFilters: [
                      SkitFilter(
                          field: 'child_id',
                          operator: FilterOperator.equals,
                          value: childId),
                    ]);
                  },
                  onRightTap: () async {
                    setState(() {
                      startOfWeek = startOfWeek.add(const Duration(days: 7));
                      endOfWeek = startOfWeek.add(const Duration(days: 6));
                    });
                    // Обновляем данные при смене недели
                    final sleepTableStore = context.read<SleepTableStore>();
                    final userStore = context.read<UserStore>();
                    final childId = userStore.selectedChild?.id ?? '';
                    
                    sleepTableStore.loadPage(newFilters: [
                      SkitFilter(
                          field: 'child_id',
                          operator: FilterOperator.equals,
                          value: childId),
                    ]);
                  },
                ),
                const SizedBox(height: 8),
                WeekTableWidget(startOfWeek: startOfWeek),
                const SizedBox(height: 8),
              ],
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                t.trackers.stories.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          const SliverToBoxAdapter(
            child: SleepHistoryTableWidget(),
          ),
        ]);
  }
}

