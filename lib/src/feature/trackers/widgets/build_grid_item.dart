import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class BuildGridItem extends StatelessWidget {
  const BuildGridItem({
    required this.time,
    required this.type,
    required this.description,
    required this.title,
    this.onTap,
    // this.color,
    // this.textColor,
    super.key,
  });

  final String time;
  final TypeOfDiapers? type;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (type) {
      TypeOfDiapers.wet => const Color(0xFFE1E6FF), // #E1E6FF для мокрого
      TypeOfDiapers.mixed => const Color(0xFFDEF8E0), // #DEF8E0 для смешанного
      TypeOfDiapers.dirty => const Color(0xFFFAF6D1), // #FAF6D1 для грязного
      _ => const Color(0xFFE1E6FF), // по умолчанию мокрый
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              title.capitalizeFirstLetter(),
              style: AppTextStyles.f14w700.copyWith(
                  color: switch (type) {
                TypeOfDiapers.wet => const Color(0xFF4D4DE8), // #4D4DE8 для мокрого
                TypeOfDiapers.mixed => const Color(0xFF059613), // #059613 для смешанного
                TypeOfDiapers.dirty => const Color(0xFFE29520), // #E29520 для грязного
                _ => const Color(0xFF4D4DE8), // по умолчанию мокрый
              }),
            ),
            Text(
              description.capitalizeFirstLetter(),
              style: AppTextStyles.f10w400,
            ),
          ],
        ),
      ),
    );
  }
}
