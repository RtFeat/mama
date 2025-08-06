import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class SelectPhotoWidget extends StatelessWidget {
  final Future Function() onTap;
  const SelectPhotoWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DashedPhotoProfile(
      backgroundColor: AppColors.primaryColorBright,
      onIconTap: () async {
        await onTap();
      },
      height: 200,
      iconHeight: 26,
      text: t.trackers.addPhoto,
      borderRadius: const BorderRadius.all(
        Radius.circular(32),
      ),
    );
  }
}
