import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class ConsultationItem extends StatelessWidget {
  final Widget child;
  final String? url;
  final Function()? onTap;
  const ConsultationItem({
    super.key,
    this.onTap,
    this.url,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.whiteDarkerButtonColor,
          borderRadius: 20.r,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AvatarWidget(url: url, size: const Size(100, 100), radius: 12),
              10.w,
              Expanded(
                child: child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
