import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';

class DrugsInputs extends StatefulWidget {
  const DrugsInputs({super.key});

  @override
  State<DrugsInputs> createState() => _DrugsInputsState();
}

class _DrugsInputsState extends State<DrugsInputs> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final AddDrugsViewStore store = context.watch<AddDrugsViewStore>();

    return BodyGroup(
      formGroup: store.formGroup,
      items: [
        BodyItemWidget(
          item: InputItem(
            controlName: 'name',
            inputHint: t.trackers.name.title,
            hintText: t.trackers.name.subTitle,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            onChanged: (value) {
              // nameDrugValue = value;
            },
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'dataStart',
            inputHint: t.trackers.dateStart.title,
            hintText: t.trackers.dateStart.subTitle,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            readOnly: true,
            onTap: (value) async {
              store.selectDate(context);
              setState(() {});
              // dateStartController.text = widget.store.formattedDateTime;
              // widget.store.formattedDateTime;
            },
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'dose',
            inputHint: t.trackers.dose.title,
            hintText: t.trackers.dose.subTitle,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            readOnly: true,
            onTap: (value) {
              store.incrementSpoons(context);
            },
            onChanged: (value) {
              // doseValue = value;
            },
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'comment',
            inputHint: t.trackers.comment.title,
            hintText: t.trackers.comment.subTitle,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            onChanged: (value) {
              // commentValue = value;
            },
          ),
        ),
      ],
    );
  }
}
