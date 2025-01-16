import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

class DateSeparatorInChat extends StatelessWidget {
  final int index;
  final MessageItem item;
  final ObservableList<MessageItem> data;
  final ScrollController scrollController;
  const DateSeparatorInChat({
    super.key,
    required this.index,
    required this.data,
    required this.item,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final previousItem = index > 0 ? data[index - 1] : null;
    final firstItem = data[data.length - 1];
    final currentDate = (item).createdAt?.toLocal();
    final previousDate =
        previousItem != null ? (previousItem).createdAt?.toLocal() : null;

    final firstItemDate = (firstItem).createdAt?.toLocal();

    // Если это первый элемент или дата отличается, показать дату
    if (currentDate != null &&
        (previousDate == null || currentDate.day != previousDate.day) &&
        currentDate.day != firstItemDate?.day) {
      return ChatDateWidget(
          scrollController: scrollController, date: currentDate);
    }
    return 20.h;
  }
}

class ChatDateWidget extends StatelessWidget {
  final DateTime date;
  final EdgeInsets? padding;
  final ScrollController scrollController;
  const ChatDateWidget(
      {super.key,
      required this.date,
      this.padding,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final DateTime now = DateTime.now();
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final bool isTomorrow = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1;

    final String dateToText = isToday
        ? t.home.today
        : isTomorrow
            ? t.home.tomorrow
            : DateFormat(
                'dd MMMM yyyy',
                TranslationProvider.of(context).flutterLocale.languageCode,
              ).format(date);

    return Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 10,
            ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dateToText,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          )
        ]));
  }
}
