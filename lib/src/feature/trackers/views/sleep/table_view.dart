import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/sleep_cry_week_table.dart';
import 'package:mama/src/feature/trackers/widgets/date_range_selector.dart';
import 'package:mama/src/feature/trackers/state/sleep/sleep_table_store.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry_table_store.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late DateTime startOfWeek;
  late DateTime endOfWeek;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final int weekday = now.weekday; // 1..7 (Mon..Sun)
    startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));
  }

  void _updateDataForDateRange() {
    // Обновляем данные в stores при изменении даты
    final userStore = context.read<UserStore>();
    final childId = userStore.selectedChild?.id;
    
    print('TableScreen _updateDataForDateRange: childId = $childId, startOfWeek = $startOfWeek, endOfWeek = $endOfWeek');
    
    if (childId != null && childId.isNotEmpty) {
      // Принудительно обновляем данные в SleepTableStore
      final sleepTableStore = context.read<SleepTableStore>();
      print('TableScreen _updateDataForDateRange: Clearing sleep data (${sleepTableStore.listData.length} items)');
      sleepTableStore.listData.clear(); // Очищаем старые данные
      sleepTableStore.loadPage(newFilters: [
        SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: childId,
        ),
      ]);
      
      // Принудительно обновляем данные в CryTableStore
      final cryTableStore = context.read<CryTableStore>();
      print('TableScreen _updateDataForDateRange: Clearing cry data (${cryTableStore.listData.length} items)');
      cryTableStore.listData.clear(); // Очищаем старые данные
      cryTableStore.loadPage(newFilters: [
        SkitFilter(
          field: 'child_id',
          operator: FilterOperator.equals,
          value: childId,
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => SleepCryStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient),
        ),
        Provider(
          key: const ValueKey('sleep_table_store_provider'),
          create: (context) => SleepTableStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              restClient: context.read<Dependencies>().restClient,
              userStore: context.read<UserStore>()),
        ),
        Provider(
          key: const ValueKey('cry_table_store_provider'),
          create: (context) => CryTableStore(
              faker: context.read<Dependencies>().faker,
              apiClient: context.read<Dependencies>().apiClient,
              restClient: context.read<Dependencies>().restClient,
              userStore: context.read<UserStore>()),
        ),
      ],
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                DateRangeSelectorWidget(
                  startDate: startOfWeek,
                  endDate: endOfWeek,
                  onLeftTap: () {
                    setState(() {
                      startOfWeek = startOfWeek.subtract(const Duration(days: 7));
                      endOfWeek = startOfWeek.add(const Duration(days: 6));
                    });
                    print('TableScreen onLeftTap: New date range = $startOfWeek to $endOfWeek');
                    // Обновляем данные при изменении даты
                    _updateDataForDateRange();
                  },
                  onRightTap: () {
                    setState(() {
                      startOfWeek = startOfWeek.add(const Duration(days: 7));
                      endOfWeek = startOfWeek.add(const Duration(days: 6));
                    });
                    print('TableScreen onRightTap: New date range = $startOfWeek to $endOfWeek');
                    // Обновляем данные при изменении даты
                    _updateDataForDateRange();
                  },
                ),
                const SizedBox(height: 8),
                SleepCryWeekTable(
                  startOfWeek: startOfWeek,
                ),
                const SizedBox(height: 8),
                TableSleepHistory(
                  key: ValueKey('table_sleep_history_${startOfWeek.toIso8601String()}'),
                  store: context.watch<SleepCryStore>(),
                  showTitle: true,
                  title: t.trackers.report,
                  childId: context.watch<UserStore>().selectedChild?.id,
                  startOfWeek: startOfWeek,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
