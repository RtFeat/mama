import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SleepMusicView extends StatelessWidget {
  final int index;
  const SleepMusicView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MusicStore(
        audioPlayerStore: context.read(),
        apiClient: context.read<Dependencies>().apiClient,
      ),
      builder: (context, child) {
        final MusicStore store = context.watch<MusicStore>();

        return _Content(index: index, store: store);
      },
    );
  }
}

class _Content extends StatefulWidget {
  final int index;
  final MusicStore store;
  const _Content({required this.index, required this.store});

  @override
  State<_Content> createState() => __ContentState();
}

class __ContentState extends State<_Content>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController =
        TabController(initialIndex: widget.index, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: t.services.sleepMusic.title,
        height: 94,
        action: const ProfileWidget(),
        tabController: _tabController,
        tabs: [
          t.services.music.title,
          t.services.whiteNoise.title,
          t.services.fairyTales.title,
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TabBarView(controller: _tabController, children: [
          MusicViewBody(
            store: widget.store,
            category: TrackCategory.music,
          ),
          MusicViewBody(
            store: widget.store,
            category: TrackCategory.whiteNoise,
          ),
          MusicViewBody(
            store: widget.store,
            category: TrackCategory.story,
          ),
        ]),
      ),
      bottomNavigationBar: const TrackPlayer(),
    );
  }
}
