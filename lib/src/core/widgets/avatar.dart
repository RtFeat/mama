import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class AvatarWidget extends StatelessWidget {
  final String? url;
  final Size size;
  final double radius;
  const AvatarWidget(
      {super.key, required this.url, required this.size, required this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height,
        width: size.width,
        child: url != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.network(
                  url!,
                  fit: BoxFit.cover,
                  cacheHeight: 256,
                  filterQuality: FilterQuality.low,
                  errorBuilder: (context, error, stackTrace) =>
                      _NoAvatar(radius: radius),
                ))
            : _NoAvatar(radius: radius));
  }
}

class _NoAvatar extends StatelessWidget {
  final double radius;
  const _NoAvatar({
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.purpleLighterBackgroundColor,
      ),
      child: const Center(
        child: Icon(Icons.person),
      ),
    );
  }
}
