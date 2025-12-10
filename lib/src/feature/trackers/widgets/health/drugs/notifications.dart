import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class DrugNotificationsWidget extends StatelessWidget {
  const DrugNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final AddDrugsViewStore store = context.watch<AddDrugsViewStore>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.trackers.dailyreminders,
              style: textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            ),
            8.h,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Observer(builder: (context) {
                return Row(
                  children: [
                    if (store.model != null) ...[
                      ...store.model!.reminder.map((e) => e.isNotEmpty
                          ? RemindItem(
                              time: e,
                              onRemove: () {
                                store.model!.reminder.remove(e);
                              },
                            )
                          : const SizedBox.shrink()),
                    ],
                    CustomButton(
                      height: 44,
                      title: t.trackers.add.title,
                      iconSize: 28,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      textStyle: textTheme.bodySmall!
                          .copyWith(color: AppColors.primaryColor),
                      icon: AppIcons.alarm,
                      iconColor: AppColors.primaryColor,
                      onTap: () async {
                        store.selectTime(context);
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
