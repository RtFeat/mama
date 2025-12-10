import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';

class CustomServiceBoxTwo extends StatelessWidget {
  final String imagePath;
  final String text;
  final Function()? onTap;

  const CustomServiceBoxTwo({
    super.key,
    required this.imagePath,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.purpleLighterBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// #text
                Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(text,
                        style: textTheme.headlineSmall!.copyWith(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                        ))),

                /// #image
                Expanded(
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage(imagePath),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
