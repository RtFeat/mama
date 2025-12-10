import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart' as skit;

class DateSeparatorInChat extends StatelessWidget {
  final int index;
  final MessageItem item;
  final MessagesStore store;
  final bool isAttachedMessages;
  final ScrollController scrollController;
  const DateSeparatorInChat({
    super.key,
    this.isAttachedMessages = false,
    required this.index,
    required this.store,
    required this.item,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final messages =
          isAttachedMessages ? store.attachedMessages : store.messages;
      final previousItem =
          index < messages.length - 1 ? messages[index + 1] : null;
      final currentDate = item.createdAt;
      final previousDate = previousItem?.createdAt;

      if (currentDate != null &&
          (previousDate == null ||
              currentDate.year != previousDate.year ||
              currentDate.month != previousDate.month ||
              currentDate.day != previousDate.day)) {
        return ChatDateWidget(
            scrollController: scrollController, date: currentDate);
      }
      return 20.h;
    });
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
