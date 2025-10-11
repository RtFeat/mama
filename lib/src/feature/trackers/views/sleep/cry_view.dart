import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/switch_container.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_widget.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_week_table.dart';
import 'package:mama/src/core/constant/generated/icons.dart';
import 'package:mama/src/feature/trackers/widgets/date_range_selector.dart';
import 'package:mama/src/feature/trackers/widgets/sleep/cry_history_table.dart';
import 'package:mama/src/feature/trackers/state/sleep/cry_table_store.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';
import 'package:mama/src/feature/trackers/state/health/temperature/info_store.dart';

class CryScreen extends StatefulWidget {
  final bool isActiveTab;
  const CryScreen({super.key, this.isActiveTab = true});

  @override
  State<CryScreen> createState() => _CryScreenState();
}

class _CryScreenState extends State<CryScreen> {
  late DateTime startOfWeek;
  late DateTime endOfWeek;
  String? _lastChildId;
  late final CryTableStore _cryTableStore;
  late final TemperatureInfoStore _infoStore;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final int weekday = now.weekday;
    startOfWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
    endOfWeek = startOfWeek.add(const Duration(days: 6));

    final deps = context.read<Dependencies>();
    _cryTableStore = CryTableStore(
      apiClient: deps.apiClient,
      restClient: deps.restClient,
      faker: deps.faker,
    );
    
    final prefs = deps.sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('cry_info') ?? true,
      onSet: (v) async => prefs.setBool('cry_info', v),
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
      _cryTableStore.loadPage(newFilters: [
        SkitFilter(
            field: 'child_id',
            operator: FilterOperator.equals,
            value: childId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _cryTableStore,
      child: TrackerBody(
          isShowInfo: _infoStore.isShowInfo,
          setIsShowInfo: (v) {
            _infoStore.setIsShowInfo(v).then((_) => setState(() {}));
          },
          learnMoreWidgetText: t.trackers.findOutMoreTextCry,
          onPressLearnMore: () {
            context.pushNamed(AppViews.serviceKnowlegde);
          },
          children: [
            const SliverToBoxAdapter(child: CryWidget()),
            SliverToBoxAdapter(
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
                      final userStore = context.read<UserStore>();
                      final childId = userStore.selectedChild?.id ?? '';
                      _cryTableStore.loadPage(newFilters: [
                        SkitFilter(
                            field: 'child_id',
                            operator: FilterOperator.equals,
                            value: childId),
                      ]);
                    },
                    onRightTap: () {
                      setState(() {
                        startOfWeek = startOfWeek.add(const Duration(days: 7));
                        endOfWeek = startOfWeek.add(const Duration(days: 6));
                      });
                      final userStore = context.read<UserStore>();
                      final childId = userStore.selectedChild?.id ?? '';
                      _cryTableStore.loadPage(newFilters: [
                        SkitFilter(
                            field: 'child_id',
                            operator: FilterOperator.equals,
                            value: childId),
                      ]);
                    },
                  ),
                  const SizedBox(height: 8),
                  CryWeekTableWidget(startOfWeek: startOfWeek),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: CryHistoryTableWidget()),
          ]),
    );
  }
}
