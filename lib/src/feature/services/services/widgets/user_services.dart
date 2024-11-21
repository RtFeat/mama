import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class UserServicesBodyWidget extends StatelessWidget {
  const UserServicesBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      /// #some space
      const SizedBox(height: 16),

      /// #knowledge center box
      MainBox(
        mainText: t.services.knowledgeCenter.title,
        image: Assets.images.hat.path,
      ),
      const SizedBox(height: 8),

      SubscribeBlockItem(
          child: Column(
        children: [
          /// #online consultation box
          MainBoxWithButtons(
            image: Assets.images.chatVideo.path,
            mainText: t.services.onlineConsultation.title,
            buttons: [
              ButtonModel(
                title: t.services.myRecords.title,
                onTap: () {
                  context.pushNamed(AppViews.consultations, extra: {
                    'selectedTab': 0,
                  });
                },
              ),
              ButtonModel(
                title: t.services.specialists.title,
                onTap: () {
                  context.pushNamed(AppViews.consultations, extra: {
                    'selectedTab': 1,
                  });
                },
              ),
              ButtonModel(
                title: t.services.onlineSchools.title,
                onTap: () {
                  context.pushNamed(AppViews.consultations, extra: {
                    'selectedTab': 2,
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 8),

          /// #music for sleep box
          MainBoxWithButtons(
            image: Assets.images.moon.path,
            mainText: t.services.sleepMusic.title,
            onTap: () => context.pushNamed(AppViews.servicesSleepMusicView),
            buttons: [
              ButtonModel(
                title: t.services.music.title,
                onTap: () {
                  context.pushNamed(AppViews.servicesSleepMusicView);
                },
              ),
              ButtonModel(
                title: t.services.whiteNoise.title,
                onTap: () {
                  context.pushNamed(AppViews.servicesSleepMusicView, extra: {
                    'selectedTab': 1,
                  });
                },
              ),
              ButtonModel(
                title: t.services.fairyTales.title,
                onTap: () {
                  context.pushNamed(AppViews.servicesSleepMusicView, extra: {
                    'selectedTab': 2,
                  });
                },
              ),
            ],
          ),
        ],
      )),
    ]);
  }
}
