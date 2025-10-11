import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/data/repository/history_repository.dart';
import 'package:mama/src/feature/trackers/widgets/feeding/breast_feeding_history_table.dart';
import 'package:mama/src/feature/trackers/state/feeding/breast_feeding_table_store.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class BreastScreen extends StatefulWidget {
  const BreastScreen({super.key});

  @override
  State<BreastScreen> createState() => _BreastScreenState();
}

class _BreastScreenState extends State<BreastScreen> {
  late final TemperatureInfoStore _infoStore;

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
        SliverToBoxAdapter(child: const AddFeedingWidget()),
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
            create: (context) => BreastFeedingTableStore(
              apiClient: context.read<Dependencies>().apiClient,
              faker: context.read<Dependencies>().faker,
              restClient: context.read<Dependencies>().restClient,
            ),
            child: const BreastFeedingHistoryTableWidget(),
          ),
        ),
      ],
    );
  }
}

