import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class AddLureScreen extends StatelessWidget {
  const AddLureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(t.feeding.addComplementaryFood,
            style: textTheme.titleMedium
                ?.copyWith(color: const Color(0xFF163C63))),
      ),
    );
  }
}
