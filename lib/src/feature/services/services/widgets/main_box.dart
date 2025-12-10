import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class MainBox extends StatelessWidget {
  final String mainText;
  final String image;
  final Function()? onTap;

  const MainBox({
    super.key,
    required this.mainText,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final UserStore userStore = context.watch<UserStore>();

    final double width = MediaQuery.of(context).size.width;

    final Widget icon = LayoutBuilder(builder: (context, constraints) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        cacheWidth: constraints.maxWidth.toInt(),
        // image: AssetImage(imagePath),
        filterQuality: FilterQuality.low,
      );
    });

    // Image(
    //   image: AssetImage(image),
    //   fit: BoxFit.cover,
    // );

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.purpleLighterBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          height: 205,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                /// #main text
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AutoSizeText(
                    mainText,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4D4DE8),
                    ),
                  ),
                ),

                /// #image

                switch (userStore.role) {
                  Role.doctor => Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                        ),
                        child: SizedBox(
                          width: width * 0.75,
                          child: icon,
                        ),
                      ),
                    ),
                  Role.onlineSchool => Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                        ),
                        child: SizedBox(
                          width: width * 0.75,
                          child: icon,
                        ),
                      ),
                    ),
                  _ => Align(
                      alignment: Alignment.topRight,
                      child: icon,
                    ),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
