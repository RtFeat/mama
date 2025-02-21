import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TrackerBody extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onPressClose;
  final VoidCallback onPressLearnMore;
  final PreferredSizeWidget? appBar;
  final Widget? stackWidget;
  final String learnMoreWidgetText;
  final Widget? bottomNavigatorBar;
  const TrackerBody(
      {super.key,
      required this.children,
      this.bottomNavigatorBar,
      required this.learnMoreWidgetText,
      this.stackWidget,
      this.appBar,
      required this.onPressClose,
      required this.onPressLearnMore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar ?? null,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              16.h,
              LearnMoreWidget(
                onPressClose: () => onPressClose(),
                onPressButton: () => onPressLearnMore(),
                title: learnMoreWidgetText,
              ),
              Column(
                children: children,
              )
            ],
          ),
        ),
        stackWidget ?? Container(),
      ]),
      bottomNavigationBar: bottomNavigatorBar,
    );
  }
}
