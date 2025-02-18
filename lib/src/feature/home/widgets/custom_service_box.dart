import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mama/src/core/core.dart';

class CustomServiceBox extends StatelessWidget {
  final String imagePath;
  final String text;
  final int maxLines;
  final Function()? onTap;

  const CustomServiceBox({
    super.key,
    required this.imagePath,
    required this.text,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 6 / 5,
        child: GestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.purpleLighterBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(26)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// #service image
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        cacheWidth: constraints.maxWidth.toInt(),
                        // image: AssetImage(imagePath),
                        filterQuality: FilterQuality.low,
                      );
                    }),
                  ),

                  /// #service text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: AutoSizeText(text,
                          maxLines: maxLines,
                          style: textTheme.headlineSmall!.copyWith(
                            fontSize: 17,
                            color: AppColors.primaryColor,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
