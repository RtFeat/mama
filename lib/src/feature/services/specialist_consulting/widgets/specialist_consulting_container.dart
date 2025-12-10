import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class SpecialistConsultingContainer extends StatelessWidget {
  final Widget child;

  const SpecialistConsultingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: AppColors.deepBlue.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 1,
                  spreadRadius: 0),
              BoxShadow(
                  color: AppColors.skyBlue.withValues(alpha: 0.15),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                  spreadRadius: 0),
            ]),
        child: child);
  }
}
