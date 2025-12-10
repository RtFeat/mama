import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/feeding/breast_feeding_history_table.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';
import 'package:mama/src/feature/trackers/widgets/add_feeding.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class BreastScreen extends StatefulWidget {
  const BreastScreen({super.key});

  @override
  State<BreastScreen> createState() => _BreastScreenState();
}

class _BreastScreenState extends State<BreastScreen> {
  late final TemperatureInfoStore _infoStore;
  BreastFeedingTableStore? _breastFeedingStore;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<Dependencies>().sharedPreferences;
    _infoStore = TemperatureInfoStore(
      onLoad: () async => prefs.getBool('feed_breast_info') ?? true,
      onSet: (v) async => prefs.setBool('feed_breast_info', v),
    );
    _infoStore.getIsShowInfo().then((_) => setState(() {}));
  }

  void _refreshBreastFeedingHistory() {
    if (_breastFeedingStore != null) {
      final childId = context.read<UserStore>().selectedChild?.id;
      if (childId != null) {
        _breastFeedingStore!.resetPagination();
        _breastFeedingStore!.loadPage(newFilters: [
          SkitFilter(field: 'child_id', operator: FilterOperator.equals, value: childId),
        ]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrackerBody(
      isShowInfo: _infoStore.isShowInfo,
      setIsShowInfo: (v) {
        _infoStore.setIsShowInfo(v).then((_) => setState(() {}));
      },
      learnMoreWidgetText: t.trackers.findOutMoreTextBrist,
      onPressLearnMore: () {
        context.pushNamed(AppViews.serviceKnowlegde);
      },
      children: [
        SliverToBoxAdapter(
          child: AddFeedingWidgetWrapper(
            onHistoryRefresh: _refreshBreastFeedingHistory,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
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
        SliverToBoxAdapter(
          child: Provider(
            create: (context) {
              _breastFeedingStore = BreastFeedingTableStore(
                apiClient: context.read<Dependencies>().apiClient,
                faker: context.read<Dependencies>().faker,
                restClient: context.read<Dependencies>().restClient,
                userStore: context.read<UserStore>(),
              );
              return _breastFeedingStore!;
            },
            child: const BreastFeedingHistoryTableWidget(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 15)), // Добавляем дополнительное пространство снизу
      ],
    );
  }
}

class AddFeedingWidgetWrapper extends StatelessWidget {
  final VoidCallback onHistoryRefresh;

  const AddFeedingWidgetWrapper({
    super.key,
    required this.onHistoryRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AddFeedingWidget(
      onHistoryRefresh: onHistoryRefresh,
    );
  }
}

