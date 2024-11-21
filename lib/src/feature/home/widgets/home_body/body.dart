import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

import 'home_school_body.dart';
import 'home_specialist_body.dart';
import 'user_body.dart';

class HomeBodyWidget extends StatelessWidget {
  final CustomAppBar appBar;
  final TabController tabController;
  const HomeBodyWidget({
    super.key,
    required this.appBar,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch();
    final HomeViewStore homeViewStore = context.watch<HomeViewStore>();

    return Scaffold(
      appBar: appBar,
      body: Observer(builder: (_) {
        switch (userStore.role) {
          case Role.user:
            return HomeUserBody(
              homeViewStore: homeViewStore,
              userStore: userStore,
              tabController: tabController,
            );
          case Role.doctor:
            return Provider(
              create: (context) => DoctorStore(
                  restClient: context.read<Dependencies>().restClient),
              builder: (context, child) => HomeSpecialistBody(
                homeViewStore: homeViewStore,
                userStore: userStore,
                doctorStore: context.watch<DoctorStore>(),
              ),
            );
          case Role.onlineSchool:
            return HomeSchoolBody(
              homeViewStore: homeViewStore,
              userStore: userStore,
            );
          default:
            return HomeUserBody(
              homeViewStore: homeViewStore,
              userStore: userStore,
              tabController: tabController,
            );
        }
      }),
    );
  }
}
