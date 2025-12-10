import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class CategoryWidget extends StatelessWidget {
  final String title;
  const CategoryWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.greyBrighterColor,
          ),
        ),
      ),
    );
  }
}
