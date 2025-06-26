import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class NoteIconWidget extends StatelessWidget {
  const NoteIconWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Todo go to note view
      },
      child: Icon(
        AppIcons.pencil,
        color: AppColors.greyLighterColor,
        size: 26,
      ),
    );
  }
}
