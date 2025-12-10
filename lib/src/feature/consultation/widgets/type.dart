import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationTypeWidget extends StatelessWidget {
  final ConsultationType type;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle? textStyle;
  final Color? iconColor;
  const ConsultationTypeWidget(
      {super.key,
      required this.type,
      this.iconColor,
      this.textStyle,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ConsultationType.chat:
        return _Widget(
          iconColor: iconColor,
          iconPath: AppIcons.messageCircleFill,

          // iconPath: Assets.icons.chatIcon,
          title: t.consultation.type.chat,
          mainAxisAlignment: mainAxisAlignment,
          textStyle: textStyle,
        );
      case ConsultationType.video:
        return _Widget(
          iconColor: iconColor,
          // iconPath: Assets.icons.videoIcon,
          iconPath: AppIcons.videoCircleFill,
          title: t.consultation.type.video,
          mainAxisAlignment: mainAxisAlignment,
          textStyle: textStyle,
        );
      case ConsultationType.express:
        return _Widget(
          iconColor: iconColor,
          // iconPath: Assets.icons.videoIcon,
          iconPath: AppIcons.videoCircleFill,
          title: t.consultation.type.express,
          textStyle: textStyle,
          mainAxisAlignment: mainAxisAlignment,
        );
    }
  }
}

class _Widget extends StatelessWidget {
  final IconData iconPath;
  final String title;
  final TextStyle? textStyle;
  final Color? iconColor;
  final MainAxisAlignment mainAxisAlignment;
  const _Widget({
    required this.iconColor,
    required this.iconPath,
    required this.textStyle,
    required this.title,
    required this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconWidget(model: IconModel(icon: iconPath, color: iconColor)),
        2.w,
        SizedBox(
            height: 20,
            child: FittedBox(
                child: AutoSizeText(
              title,
              style: textStyle ??
                  textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ))),
      ],
    );
  }
}
