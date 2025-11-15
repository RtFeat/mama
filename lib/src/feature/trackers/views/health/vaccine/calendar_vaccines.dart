import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/services/pdf_service.dart';
import 'package:skit/skit.dart';

class CalendarVaccines extends StatefulWidget {
  const CalendarVaccines({
    super.key,
  });

  @override
  State<CalendarVaccines> createState() => _CalendarVaccinesState();
}

class _CalendarVaccinesState extends State<CalendarVaccines> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: t.trackers.vaccines.calendarViewAppBar,
        appBarColor: AppColors.e8ddf9,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 17, color: AppColors.blueDark),
      ),
      backgroundColor: AppColors.primaryColorBright,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CalendarVaccineContainer(
              nameCalendar: t.trackers.vaccines.calendarViewRecomended,
              organization: t.trackers.vaccines.calendarViewRecomendedOrg,
              onTapPDF: () {
                PdfService.openLocalVaccinePdf(
                  context: context,
                  assetPath: 'assets/docs/National.pdf',
                  title: t.trackers.vaccines.calendarViewRecomendedShort,
                  onStart: () => _showSnack(context, 'Открытие PDF...', bg: const Color(0xFFE1E6FF)),
                  onSuccess: () {},
                  onError: (message) => _showSnack(context, message),
                );
              },
            ),
            16.h,
            CalendarVaccineContainer(
              nameCalendar: t.trackers.vaccines.calendarViewIdeal,
              organization: t.trackers.vaccines.calendarViewIdealOrg,
              onTapPDF: () {
                PdfService.openLocalVaccinePdf(
                  context: context,
                  assetPath: 'assets/docs/Ideal.pdf',
                  title: t.trackers.vaccines.calendarViewIdealShort,
                  onStart: () => _showSnack(context, 'Открытие PDF...', bg: const Color(0xFFE1E6FF)),
                  onSuccess: () {},
                  onError: (message) => _showSnack(context, message),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext ctx, String message, {Color? bg, int seconds = 2}) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        // Определяем цвет текста в зависимости от сообщения
        Color textColor = Colors.white; // по умолчанию
        if (message == 'Генерация PDF...') {
          textColor = const Color(0xFF4D4DE8); // primaryColor
        }
        
        ScaffoldMessenger.of(ctx)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            backgroundColor: bg,
            duration: Duration(seconds: seconds),
          ));
      } catch (e) {
        // Ignore snackbar errors
      }
    });
  }
}
