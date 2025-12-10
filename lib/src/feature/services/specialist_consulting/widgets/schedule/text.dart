import 'package:flutter/material.dart';

class SpecialistTextWidget extends StatelessWidget {
  final String text;
  final bool isTitle;
  const SpecialistTextWidget(
      {super.key, required this.text, required this.isTitle});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: isTitle
              ? textTheme.bodyMedium?.copyWith(color: Colors.black)
              : textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
    );
  }
}
