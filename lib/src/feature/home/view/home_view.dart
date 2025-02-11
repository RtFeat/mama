import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();
    final ChatSocket socket = context.watch<ChatSocket>();
    final FirebaseMessageStore firebaseMessageStore = context.watch();

    return LoadHomeData(
        userStore: userStore,
        child: _Body(
          socket: socket,
          userStore: userStore,
          store: context.watch(),
          firebaseMessageStore: firebaseMessageStore,
        ));
  }
}

class _Body extends StatefulWidget {
  final UserStore userStore;
  final ChatSocket socket;
  final HomeViewStore store;
  final FirebaseMessageStore firebaseMessageStore;
  const _Body({
    required this.socket,
    required this.userStore,
    required this.store,
    required this.firebaseMessageStore,
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
    widget.socket.initializeSocket();
    widget.firebaseMessageStore.init();
  }

  @override
  Widget build(BuildContext context) {
    final CustomAppBar appBar = CustomAppBar(
      leading: Observer(builder: (context) {
        return ProfileWidget(
          onTap: () {
            router.pushNamed(AppViews.profile);
          },
          alignment: Alignment.centerLeft,
          avatarUrl: widget.userStore.account.avatarUrl ?? '',
        );
      }),
      action: ProfileWidget(
        isShowText: true,
        onTapSwitch: () {
          switch (_tabController.index) {
            case 2:
              if (widget.userStore.role == Role.user) {
                final store =
                    Provider.of<ChatsViewStore>(context, listen: false);

                store.groups.resetPagination();

                store.loadAllGroups(
                  widget.userStore.selectedChild?.id,
                );
              }
              break;
            default:
          }
        },
      ),
    );

    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeBodyWidget(
              tabController: _tabController,
              appBar: CustomAppBar(
                leading: Observer(builder: (context) {
                  return ProfileWidget(
                    onTap: () {
                      router.pushNamed(AppViews.profile);
                    },
                    alignment: Alignment.centerLeft,
                    avatarUrl: widget.userStore.account.avatarUrl ?? '',
                  );
                }),
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
