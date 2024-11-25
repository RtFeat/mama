import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    return Provider(
      create: (context) => HomeViewStore(
          restClient: context.read<Dependencies>().restClient,
          userId: userStore.user.id),
      builder: (context, _) {
        return LoadHomeData(
            userStore: userStore,
            child: _Body(
              userStore: userStore,
              store: context.watch(),
            ));
      },
    );
  }
}

class _Body extends StatefulWidget {
  final UserStore userStore;
  final HomeViewStore store;
  const _Body({
    required this.userStore,
    required this.store,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isUser = false;

  @override
  void initState() {
    super.initState();
    isUser = widget.userStore.role == Role.user;
    _tabController = TabController(length: isUser ? 4 : 3, vsync: this);
  }

  late final Widget leadingWidget = ProfileWidget(
    onTap: () {
      router.pushNamed(AppViews.profile, extra: {
        'store': widget.store,
      });
    },
    alignment: Alignment.centerLeft,
    avatarUrl: widget.userStore.account.avatarUrl ?? '',
  );

  late CustomAppBar appBar = CustomAppBar(
    leading: ProfileWidget(
      onTap: () {
        router.pushNamed(AppViews.profile);
      },
      alignment: Alignment.centerLeft,
      avatarUrl: widget.userStore.account.avatarUrl ?? '',
    ),
    action: const ProfileWidget(
      isShowText: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeBodyWidget(
              tabController: _tabController,
              appBar: CustomAppBar(
                leading: leadingWidget,
                action: switch (widget.userStore.role) {
                  Role.user => ProfileWidget(
                      isShowText: true,
                      onTapSwitch: () {},
                    ),
                  Role.doctor => TextButton(
                      onPressed: () {
                        context.pushNamed(AppViews.specializedConsultations);
                      },
                      child: Text(t.consultation.title),
                    ),
                  _ => null,
                },
                // action: widget.userStore.role,
              ),
            ),
            if (isUser)
              TrackersView(
                appBar: appBar,
              ),
            ChatsListScreen(
              appBar: appBar,
            ),
            ServicesView(
              appBar: appBar,
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          isUser: isUser,
          tabController: _tabController,
        ));
  }
}
