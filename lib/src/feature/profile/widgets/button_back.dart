import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class ButtonLeading extends StatelessWidget {
  final VoidCallback onTapButton;
  final TextStyle? labelStyle;
  final BorderRadius borderRadius;
  final String title;
  final Widget icon;
  final IconAlignment iconAlignment;

  const ButtonLeading({
    super.key,
    required this.title,
    required this.onTapButton,
    this.labelStyle,
    required this.borderRadius,
    required this.icon,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton.icon(
        iconAlignment: iconAlignment,
        style: ElevatedButton.styleFrom(
          // fixedSize: const Size(100, 46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: AppColors.greyButton,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        onPressed: () {
          onTapButton();
        },
        icon: icon,
        label: Text(
          title,
          style: labelStyle,
        ),
      ),
    );
  }
}
