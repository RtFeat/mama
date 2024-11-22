import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class SpecialistServicesBodyWidget extends StatelessWidget {
  const SpecialistServicesBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: MainBox(
              mainText: t.services.knowledgeCenter.title,
              image: Assets.images.hat.path,
            ),
          ),
          12.h,
          Expanded(
            child: MainBox(
              mainText: t.home.onlineConsultation.title,
              image: Assets.images.chatVideo.path,
              onTap: () {
                context.pushNamed(AppViews.specialistConsultations);
              },
            ),
          ),
        ],
      ),
    );
  }
}
