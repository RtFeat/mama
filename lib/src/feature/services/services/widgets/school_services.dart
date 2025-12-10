import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';

class SchoolServicesBodyWidget extends StatelessWidget {
  const SchoolServicesBodyWidget({super.key});

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
              onTap: () {
                context.pushNamed(AppViews.serviceKnowlegde);
              },
            ),
          ),
        ],
      ),
    );
  }
}
