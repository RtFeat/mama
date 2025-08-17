import 'package:flutter/material.dart';
import 'package:mama/src/core/widgets/body/decoration.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

class EditMedicineDialog extends StatefulWidget {
  final String medicineName;
  final String dateAndTime;
  final Function(DateTime?) onPressFinishMedicine;
  const EditMedicineDialog(
      {super.key,
      required this.medicineName,
      required this.dateAndTime,
      required this.onPressFinishMedicine});

  @override
  State<EditMedicineDialog> createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<EditMedicineDialog> {
  DateTime? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Dialog(
        insetPadding: const EdgeInsets.all(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BodyItemDecoration(
            shadow: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.trackers.finishMedicine.title,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall!.copyWith(
                            fontSize: 20, color: AppColors.greyBrighterColor),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                  8.h,
                  Text(
                    widget.medicineName,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall!.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  15.h,
                  Text(
                    t.trackers.finishMedicine.dateTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall,
                  ),
                  16.h,
                  // DateSwitchContainer(
                  //   title1: t.trackers.now.title,
                  //   title2: t.trackers.sixTeenThirtyTwo.title,
                  //   title3: t.trackers.fourteensOfSeptember.title,
                  // ),
                  DateTimeSelectorWidget(
                    onChanged: (value) {
                      _selectedTime = value;
                    },
                  ),
                  20.h,
                  Text(
                    t.trackers.finishMedicine.comment1,
                    style: textTheme.titleSmall,
                  ),
                  8.h,
                  Text(
                    t.trackers.finishMedicine.comment2,
                    style: textTheme.titleSmall,
                  ),
                  20.h,
                  CustomButton(
                    title: t.trackers.medicines.finish,
                    width: MediaQuery.of(context).size.width,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    maxLines: 1,
                    textStyle: textTheme.bodyMedium!
                        .copyWith(color: AppColors.primaryColor),
                    onTap: () => widget.onPressFinishMedicine(_selectedTime),
                    icon: AppIcons.pillsFill,
                    iconSize: 28,
                    iconColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
