import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class SubscribeBlockItem extends StatelessWidget {
  final Widget child;
  const SubscribeBlockItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final UserStore userStore = context.watch();

    final TextStyle titlesStyle =
        textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400);

    return Observer(builder: (context) {
      final bool userIsPro = userStore.isPro || userStore.role != Role.user;

      return Stack(
        children: [
          Opacity(
            opacity: !userIsPro ? 0.25 : 1,
            child: AbsorbPointer(absorbing: !userIsPro, child: child),
          ),
          if (!userIsPro)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Image.asset(
                  //   height: 80,
                  //   Assets.icons.padlock.path,
                  // ),
                  const Icon(AppIcons.lockFill,
                      size: 80, color: AppColors.primaryColor),
                  30.h,
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: 16.r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.profile.subscribeBlockTitle,
                            style: textTheme.headlineSmall!.copyWith(
                                fontSize: 20, color: AppColors.primaryColor)),
                        16.h,
                        Text(t.profile.subscribeBlockSubitle,
                            style: titlesStyle),
                        16.h,
                        CustomButton(
                          isSmall: false,
                          title: t.profile.subscribeBlocButtonTitle,
                          onTap: () {
                            context.pushNamed(AppViews.webView, extra: {
                              'url': 'https://google.com',
                            });
                          },
                          icon: AppIcons.globe,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      );
    });
  }
}
