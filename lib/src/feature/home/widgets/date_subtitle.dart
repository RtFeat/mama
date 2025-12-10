import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';

class DateSubtitle extends StatelessWidget {
  const DateSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final String locale =
        TranslationProvider.of(context).flutterLocale.languageCode;

    final DateTime today = DateTime.now();

    String dayOfWeek = DateFormat.EEEE(locale).format(today);
    String day = DateFormat.d(locale).format(today);

    return AutoSizeText(
      '${t.home.today} $dayOfWeek $day ${t.home.monthsData.withNumbers[today.month - 1]}',
      style: textTheme.titleSmall,
      maxLines: 1,
    );
  }
}
