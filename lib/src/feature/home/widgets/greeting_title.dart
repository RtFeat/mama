import 'package:flutter/material.dart';

class GreetingTitle extends StatelessWidget {
  final String title;

  const GreetingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Text(
      title,
      style: textTheme.headlineLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
