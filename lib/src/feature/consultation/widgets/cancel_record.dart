import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class CancelRecordWidget extends StatelessWidget {
  const CancelRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return AlertDialog(
      title: Text(
        t.consultation.cancel.title,
        style: textTheme.headlineSmall?.copyWith(
          color: AppColors.redColor,
          fontSize: 20,
        ),
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: t.consultation.cancel.content
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      e,
                      style: textTheme.titleSmall?.copyWith(),
                      maxLines: 3,
                    ),
                  ))
              .toList()),
      actions: [
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 50,
                  child: CustomButton(
                    title: t.services.back.title,
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
              ),
              10.w,
              Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 50,
                    child: CustomButton(
                      title: t.consultation.cancel.title,
                      textStyle: textTheme.bodyMedium?.copyWith(
                        color: AppColors.redColor,
                      ),
                      backgroundColor: AppColors.redLighterBackgroundColor,
                      // icon: IconModel(
                      //   icon: Icons.language,
                      //   color: AppColors.redColor,
                      // ),

                      icon: AppIcons.globe,
                      iconColor: AppColors.redColor,
                      onTap: () {
                        context.pop();
                        context.pushNamed(AppViews.webView,
                            extra: {'url': 'https://www.google.com/'});
                      },
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
