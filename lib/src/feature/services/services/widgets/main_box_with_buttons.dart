import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/services/services/model/button_model.dart';
import 'package:skit/skit.dart';

class MainBoxWithButtons extends StatelessWidget {
  final String image;
  final String mainText;
  final Function()? onTap;
  final List<ButtonModel> buttons;

  const MainBoxWithButtons({
    super.key,
    this.onTap,
    required this.image,
    required this.mainText,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.purpleLighterBackgroundColor,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: SizedBox(
          height: 205,
          child: Row(
            children: [
              /// #image and main text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      /// #image
                      // Expanded(
                      //   child: SvgPicture.asset(image),
                      // ),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Image.asset(
                            image,
                            fit: BoxFit.contain,
                            cacheWidth: constraints.maxWidth.toInt(),
                            // image: AssetImage(imagePath),
                            filterQuality: FilterQuality.low,
                          );
                        }),
                      ),

                      /// #main text
                      AutoSizeText(
                        mainText,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              12.w,

              /// #three buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: buttons.map(
                      (button) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: CustomButton(
                              isSmall: false,
                              title: button.title,
                              onTap: button.onTap,
                              maxLines: 1,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
