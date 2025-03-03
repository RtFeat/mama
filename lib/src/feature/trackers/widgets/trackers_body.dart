import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class TrackerBody extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onPressClose;
  final VoidCallback onPressLearnMore;
  final PreferredSizeWidget? appBar;
  final Widget? stackWidget;
  final bool isShowLearnMore;
  final String learnMoreWidgetText;
  final Widget? bottomNavigatorBar;

  final LearnMoreStore? learnMoreStore;
  const TrackerBody(
      {super.key,
      this.learnMoreStore,
      this.isShowLearnMore = true,
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
      appBar: appBar,
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Observer(builder: (context) {
            return CustomScrollView(
              slivers: [
                if (learnMoreStore != null &&
                    (learnMoreStore?.isShowInfo ?? true)) ...[
                  SliverToBoxAdapter(child: 16.h),
                  SliverToBoxAdapter(
                    child: LearnMoreWidget(
                      onPressClose: () => onPressClose(),
                      onPressButton: () => onPressLearnMore(),
                      title: learnMoreWidgetText,
                    ),
                  ),
                ],
                ...children,
              ],
            );
          }),
        ),
        stackWidget ?? const SizedBox.shrink(),
      ]),
      bottomNavigationBar: bottomNavigatorBar,
    );
  }
}
