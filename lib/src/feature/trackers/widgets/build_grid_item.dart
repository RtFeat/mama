import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class BuildGridItem extends StatelessWidget {
  const BuildGridItem({
    required this.time,
    required this.type,
    required this.description,
    required this.title,
    // this.color,
    // this.textColor,
    super.key,
  });

  final String time;
  final TypeOfDiapers? type;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (type) {
      TypeOfDiapers.mixed => AppColors.greenLighterBackgroundColor,
      TypeOfDiapers.dirty => AppColors.yellowBackgroundColor,
      _ => AppColors.purpleLighterBackgroundColor,
    };

    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: 8.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: AppTextStyles.f10w400,
          ),
          Text(
            // type?.name.capitalizeFirstLetter() ?? '',
            title.capitalizeFirstLetter(),
            style: AppTextStyles.f14w700.copyWith(
                color: switch (type) {
              TypeOfDiapers.mixed => AppColors.greenLightTextColor,
              TypeOfDiapers.dirty => AppColors.orangeTextColor,
              _ => color.getDarkerColor(.4),
            }),
          ),
          Text(
            description.capitalizeFirstLetter(),
            style: AppTextStyles.f10w400,
          ),
        ],
      ),
    );
  }
}
