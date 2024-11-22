import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class ScheduleSlotsWidget extends StatelessWidget {
  const ScheduleSlotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleViewStore store = context.watch();

    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final TextStyle? standartStyle = textTheme.labelSmall?.copyWith(
      fontSize: 10,
      color: AppColors.greenLightTextColor,
    );

    final TextStyle? warningStyle = textTheme.labelSmall?.copyWith(
      fontSize: 10,
      color: AppColors.orangeTextColor,
    );

    final TextStyle? timeStyle = textTheme.labelLarge?.copyWith(
      color: Colors.black,
    );

    return Observer(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...store.workSlots.mapIndexed((i, e) {
            final slots = store.distributedSlots[i];
            final bool hasOverflow = slots.any((item) => item['overflow']);

            final DateFormat dateFormat = DateFormat('HH:mm');
            final List<String> time = store.workSlots[i].split(' - ');
            DateTime startTime = dateFormat.parse(time.first);
            DateTime endTime = dateFormat.parse(time.last);

            String formattedStartTime = dateFormat.format(startTime);
            String formattedEndTime = dateFormat.format(endTime);

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formattedStartTime, style: timeStyle),
                      Row(
                        children: [
                          if (hasOverflow)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconWidget(
                                  model: IconModel(
                                iconPath: Assets.icons.warning,
                              )),
                            ),
                          Text(formattedEndTime, style: timeStyle),
                        ],
                      ),
                    ],
                  ),
                  2.h,
                  ItemsLineWidget(
                    height: 40,
                    backgroundColor: AppColors.greenLighterBackgroundColor,
                    data: slots,
                    builder: (data, isFirst, isLast) {
                      final bool isOverflow = data['overflow'];

                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: isOverflow
                              ? AppColors.yellowBackgroundColor
                              : null,
                          borderRadius: isLast && isOverflow
                              ? const BorderRadius.horizontal(
                                  right: Radius.circular(24))
                              : null,
                        ),
                        child: slots.length < 10
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(data['start'],
                                      minFontSize: 6, style: standartStyle),
                                  AutoSizeText(data['end'],
                                      minFontSize: 6,
                                      style: isOverflow
                                          ? warningStyle
                                          : standartStyle),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
                ],
              ),
            );
          })
        ],
      );
    });
  }
}
