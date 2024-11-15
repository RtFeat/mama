
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mama/src/core/core.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: CustomButton(
        backgroundColor: AppColors.lightBlueBackgroundStatus,
        onTap: (){},
        title: "Сохранить",
        icon: IconModel(
          iconPath: Assets.icons.calendar,
          color: AppColors.primaryColor
        ),
      ),
    );
  }
}
