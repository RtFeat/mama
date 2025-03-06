import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class BuilldGridItem extends StatelessWidget {
  const BuilldGridItem({
    required this.time,
    required this.type,
    required this.description,
    // this.color,
    // this.textColor,
    super.key,
  });

  final String time;
  final String type;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (type) {
      // TODO change colors from design
      'Грязный' => AppColors.purpleLighterBackgroundColor,
      'Смешанный' => AppColors.redColor,
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
            type.capitalizeFirstLetter(),
            style:
                AppTextStyles.f14w700.copyWith(color: color.getDarkerColor(.5)),
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
