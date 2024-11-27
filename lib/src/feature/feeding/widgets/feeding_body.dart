import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class TrackerBody extends StatelessWidget {
  final List<Widget> children;
  final String learnMoreWidgetText;
  final Widget? bottomNavigatorBar;
  const TrackerBody(
      {super.key,
      required this.children,
      this.bottomNavigatorBar,
      required this.learnMoreWidgetText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            16.h,
            LearnMoreWidget(
              onPressClose: () {},
              onPressButton: () {},
              title: learnMoreWidgetText,
            ),
            Column(
              children: children,
            )
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigatorBar,
    );
  }
}
