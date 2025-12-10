import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class VisitInputsWidget extends StatefulWidget {
  final AddDoctorVisitViewStore store;
  const VisitInputsWidget({super.key, required this.store});

  @override
  State<VisitInputsWidget> createState() => _VisitInputsWidgetState();
}

class _VisitInputsWidgetState extends State<VisitInputsWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return BodyGroup(
      formGroup: widget.store.formGroup,
      items: [
        BodyItemWidget(
          item: InputItem(
            controlName: 'doctor',
            inputHint: t.trackers.doctor.addNewVisitField1Title,
            hintText: t.trackers.doctor.addNewVisitField1Hint,
            textInputAction: TextInputAction.next,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            onChanged: (value) {
              // nameDoctor = value;
              // widget.store.updateData();
            },
            decorationPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'dataStart',
            inputHint: t.trackers.doctor.addNewVisitField2Title,
            hintText: t.trackers.doctor.addNewVisitField2Hint,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            // controller: dateStartController,
            readOnly: true,
            onTap: (value) async {
              widget.store.selectDate(context);
              setState(() {});
              // dateStartController.text = widget.store.formattedDateTime;
              // widget.store.formattedDateTime;
              // widget.store.updateData();
            },
            decorationPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'clinic',
            inputHint: t.trackers.doctor.addNewVisitField3Title,
            hintText: t.trackers.doctor.addNewVisitField3Hint,
            textInputAction: TextInputAction.next,
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            onChanged: (value) {
              // clinicValue = value;
              // widget.store.updateData();
            },
            decorationPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          ),
        ),
        BodyItemWidget(
          item: InputItem(
            controlName: 'comment',
            inputHint: t.trackers.doctor.addNewVisitField4Title,
            hintText: t.trackers.doctor.addNewVisitField4Hint,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            inputHintStyle: textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
            titleStyle:
                textTheme.bodySmall!.copyWith(color: AppColors.blackColor),
            maxLines: 1,
            onChanged: (value) {
              // commentValue = value;
              // widget.store.updateData();
            },
            decorationPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
          ),
        ),
      ],
    );
  }
}
