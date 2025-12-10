import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class NoteIconWidget extends StatelessWidget {
  final double? size;
  const NoteIconWidget({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Todo go to note view
      },
      child: Icon(
        AppIcons.pencil,
        color: AppColors.greyLighterColor,
        size: size ?? 26,
      ),
    );
  }
}
