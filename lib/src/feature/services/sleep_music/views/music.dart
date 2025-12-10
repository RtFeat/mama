import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SleepMusicView extends StatelessWidget {
  final int index;
  const SleepMusicView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MusicStore(
        faker: context.read<Dependencies>().faker,
        audioPlayerStore: context.read(),
        apiClient: context.read<Dependencies>().apiClient,
      ),
      dispose: (_, store) => store.dispose(),
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
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: CustomAppBar(
        title: t.services.sleepMusic.title,
        height: 114,
        action: const ProfileWidget(),
        tabController: _tabController,
        tabs: [
          t.services.music.title,
          t.services.whiteNoise.title,
          t.services.fairyTales.title,
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
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
          ),
          // Плеер - TrackPlayer сам управляет своей видимостью
          const TrackPlayer(),
        ],
      ),
      bottomNavigationBar: const _BottomNavigationWrapper(),
    );
  }
}

class _BottomNavigationWrapper extends StatelessWidget {
  const _BottomNavigationWrapper();

  void _onItemTapped(BuildContext context, int index) {
    // Если нажали на текущий раздел (Сервисы), ничего не делаем
    if (index == 3) return;
    
    // Сначала переключаем вкладку на главном экране (мгновенно, без анимации)
    if (homeTabController != null) {
      // index 0 = Главная, 1 = Дневники, 2 = Чаты, 3 = Сервисы
      homeTabController!.index = index;
    }
    
    // Затем закрываем текущий экран без анимации
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _CustomBottomBar(
      selectedIndex: 3, // Всегда показываем "Сервисы" как активную
      onItemTapped: (index) => _onItemTapped(context, index),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  
  const _CustomBottomBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final List<_NavItem> items = [
      _NavItem(
        title: t.profile.bottomBarHome,
        iconPath: const Icon(AppIcons.house, color: AppColors.greyLighterColor),
        iconPathTap: const Icon(AppIcons.houseFill, color: AppColors.primaryColor),
      ),
      _NavItem(
        title: t.profile.bottomBarDiaries,
        iconPath: const Icon(AppIcons.chartXyaxisLine, color: AppColors.greyLighterColor),
        iconPathTap: const Icon(AppIcons.chartXyaxisLine, color: AppColors.primaryColor),
      ),
      _NavItem(
        title: t.profile.bottomBarChats,
        iconPath: const Icon(AppIcons.bubbleLeftFill, color: AppColors.greyLighterColor),
        iconPathTap: const Icon(AppIcons.bubbleLeftFill, color: AppColors.primaryColor),
      ),
      _NavItem(
        title: t.profile.bottomBarServices,
        iconPath: const Icon(AppIcons.rectanglesGroupFill, color: AppColors.greyLighterColor),
        iconPathTap: const Icon(AppIcons.rectanglesGroup, color: AppColors.primaryColor),
      ),
    ];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 84,
          color: AppColors.lightPirple,
        ),
        Positioned(
          bottom: 15,
          child: SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                final int index = entry.key;
                final _NavItem item = entry.value;
                return _NavItemWidget(
                  item: item,
                  index: index,
                  selectedIndex: selectedIndex,
                  onItemTapped: onItemTapped,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final String title;
  final Icon iconPath;
  final Icon iconPathTap;
  
  _NavItem({
    required this.title,
    required this.iconPath,
    required this.iconPathTap,
  });
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final int index;
  final int selectedIndex;
  final Function(int) onItemTapped;
  
  const _NavItemWidget({
    required this.item,
    required this.index,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4.5,
        child: selectedIndex != index
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.iconPath,
                  Text(
                    item.title,
                    style: textTheme.labelSmall,
                  ),
                ],
              )
            : SizedBox(
                height: 62,
                width: 88,
                child: Card(
                  color: AppColors.whiteColor,
                  shadowColor: AppColors.skyBlue,
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.iconPathTap,
                      Text(
                        item.title,
                        style: textTheme.labelSmall!.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}