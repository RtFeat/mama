import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Alignment? alignment;
  final EdgeInsets? padding;
  final Widget? leading;
  final Widget? titleWidget;
  final double? height;
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? action;
  final bool? isScrollable;

  final TabController? tabController;
  final List<String>? tabs;

  const CustomAppBar(
      {super.key,
      this.leading,
      this.title,
      this.height,
      this.tabs,
      this.tabController,
      this.action,
      this.alignment,
      this.titleWidget,
      this.padding,
      this.isScrollable,
      this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return SafeArea(
      child: Column(
        children: [
          Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                alignment: alignment ?? Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: leading ??
                        const Row(
                          children: [
                            CustomBackButton(),
                          ],
                        ),
                  ),
                  if (titleWidget != null)
                    Align(alignment: Alignment.center, child: titleWidget),
                  if (title != null)
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title!,
                        style: titleTextStyle ?? textTheme.titleLarge,
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: action ??
                        const SizedBox(
                          width: 40,
                          height: 40,
                        ),
                  ),
                ],
              )),
          if (tabs != null && tabController != null) ...[
            10.h,
            Positioned(
              bottom: 0,
              child: TabBar(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  // Use the default focused overlay color
                  return states.contains(WidgetState.focused)
                      ? null
                      : Colors.transparent;
                }),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                isScrollable: isScrollable ?? true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                controller: tabController,
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                indicatorPadding: EdgeInsets.zero,
                indicator: const ShapeDecoration(
                  color: Colors.white,
                  shape: WaveContainer(),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(8),
                  //   topRight: Radius.circular(8),
                  // ),
                  // shadows: [
                  //   BoxShadow(
                  //     color: AppColors.deepBlue.withOpacity(0.1),
                  //     blurRadius: 1.0,
                  //     offset: const Offset(
                  //       0,
                  //       2,
                  //     ),
                  //   ),
                  //   BoxShadow(
                  //     color: AppColors.skyBlue.withOpacity(0.15),
                  //     blurRadius: 8.0,
                  //     offset: const Offset(
                  //       0,
                  //       3,
                  //     ),
                  //   ),
                  // ],
                  // color: AppColors.whiteColor,
                ),
                tabs: tabs!.map((e) => Tab(text: e)).toList(),
              ),
            )
          ]
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

class WaveContainer extends ShapeBorder {
  final bool usePadding;

  const WaveContainer({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.symmetric(
        horizontal: usePadding ? 20 : 0,
      );

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight + const Offset(0, 2));
    return Path()
      ..addRRect(RRect.fromRectAndCorners(rect,
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10)))
      ..moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..lineTo(rect.bottomLeft.dx - 10, rect.bottomLeft.dy)
      ..quadraticBezierTo(rect.bottomLeft.dx, rect.bottomLeft.dy,
          rect.bottomLeft.dx, rect.bottomLeft.dy - 10)
      ..moveTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomRight.dx + 10, rect.bottomRight.dy)
      ..quadraticBezierTo(rect.bottomRight.dx, rect.bottomRight.dy,
          rect.bottomRight.dx, rect.bottomRight.dy - 10)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
