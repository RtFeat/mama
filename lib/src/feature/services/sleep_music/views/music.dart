import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SleepMusicView extends StatefulWidget {
  final int index;
  const SleepMusicView({super.key, required this.index});

  @override
  State<SleepMusicView> createState() => _SleepMusicViewState();
}

class _SleepMusicViewState extends State<SleepMusicView>
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
    return Provider(
      create: (context) => MusicStore(
        audioPlayerStore: context.read(),
        restClient: context.read<Dependencies>().restClient,
      ),
      builder: (context, child) {
        final MusicStore store = context.watch<MusicStore>();

        return Scaffold(
          appBar: CustomAppBar(
            title: t.services.sleepMusic.title,
            height: 120,
            action: const ProfileWidget(),
            tabController: _tabController,
            tabs: [
              t.services.music.title,
              t.services.whiteNoise.title,
              t.services.fairyTales.title,
            ],
          ),
          body: TabBarView(controller: _tabController, children: [
            MusicViewBody(
              store: store,
            ),
            MusicViewBody(
              store: store,
            ),
            MusicViewBody(
              store: store,
            ),
          ]),
          bottomNavigationBar: const TrackPlayer(),
        );
      },
    );
  }
}
