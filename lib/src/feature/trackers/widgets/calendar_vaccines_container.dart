import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:skit/skit.dart';

class CalendarVaccineContainer extends StatelessWidget {
  final String nameCalendar;
  final VoidCallback onTapPDF;
  const CalendarVaccineContainer({
    super.key,
    required this.nameCalendar,
    required this.onTapPDF,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 116,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      nameCalendar,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    5.h,
                    AutoSizeText(
                      t.trackers.vaccines.calendarViewVOZ,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onTapPDF(),
                child: Container(
                  width: 67,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      t.trackers.vaccines.pdf,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
