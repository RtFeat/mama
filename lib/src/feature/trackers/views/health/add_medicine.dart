import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

enum AddMedicineType { add, edit }

class AddMedicine extends StatefulWidget {
  const AddMedicine({
    super.key,
    required this.store,
    this.titlesStyle,
    required this.medicineStore,
    required this.type,
  });

  final DrugViewStore store;
  final MedicineStore medicineStore;
  final TextStyle? titlesStyle;
  final AddMedicineType type;

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final dateStartController = TextEditingController();

  @override
  void initState() {
    widget.store.init();
    super.initState();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    String? nameDrugValue = '';
    String? doseValue = '';
    String? commentValue = '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: widget.type == AddMedicineType.add
            ? t.trackers.medicines.add
            : t.trackers.medicines.edit,
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
            Observer(builder: (context) {
              return widget.store.image == null
                  ? DashedPhotoProfile(
                      onIconTap: () async {
                        await widget.store.pickImage();
                      },
                      height: 358,
                      iconHeight: 26,
                      text: t.trackers.addPhoto,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32),
                      ),
                    )
                  : const ProfilePhoto(
                      isShowIcon: false,
                      height: 358,
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    );
            }),
            20.h,
            BodyGroup(
              formGroup: widget.store.formGroup,
              items: [
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'nameDrug',
                    inputHint: t.trackers.name.title,
                    hintText: t.trackers.name.subTitle,
                    inputHintStyle:
                        textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                    titleStyle: textTheme.bodySmall!
                        .copyWith(color: AppColors.blackColor),
                    maxLines: 1,
                    onChanged: (value) {
                      nameDrugValue = value;
                    },
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'dataStart',
                    inputHint: t.trackers.dateStart.title,
                    hintText: t.trackers.dateStart.subTitle,
                    inputHintStyle:
                        textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                    titleStyle: textTheme.bodySmall!
                        .copyWith(color: AppColors.blackColor),
                    maxLines: 1,
                    controller: dateStartController,
                    readOnly: true,
                    onTap: (value) async {
                      dateStartController.text = widget.store.formattedDateTime;
                      widget.store.formattedDateTime;
                    },
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'dose',
                    inputHint: t.trackers.dose.title,
                    hintText: t.trackers.dose.subTitle,
                    inputHintStyle:
                        textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                    titleStyle: textTheme.bodySmall!
                        .copyWith(color: AppColors.blackColor),
                    maxLines: 1,
                    onChanged: (value) {
                      doseValue = value;
                    },
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'comment',
                    inputHint: t.trackers.comment.title,
                    hintText: t.trackers.comment.subTitle,
                    inputHintStyle:
                        textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                    titleStyle: textTheme.bodySmall!
                        .copyWith(color: AppColors.blackColor),
                    maxLines: 1,
                    onChanged: (value) {
                      commentValue = value;
                    },
                  ),
                ),
              ],
            ),
            16.h,
            Container(
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
                      style: textTheme.bodySmall!
                          .copyWith(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 8),
                    Observer(builder: (context) {
                      return Row(
                        children: [
                          // TODO добавить напоминание по времени
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorBrighter,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Icon(
                                  AppIcons.alarmFill,
                                  color: AppColors.primaryColor,
                                  size: 28,
                                ),
                                5.w,
                                Text(
                                  widget.store.formattedTime,
                                  style: textTheme.bodySmall!
                                      .copyWith(color: AppColors.blackColor),
                                ),
                                5.w,
                                InkWell(
                                  onTap: () {
                                    // TODO нажатие удалить напоминание
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 28,
                                    color: AppColors.redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.store.formattedTime == ''
                              ? const SizedBox()
                              : const SizedBox(width: 16),
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
                              await widget.store.pickTime(context);
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            widget.type == AddMedicineType.add
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          title: t.trackers.medicines.delete,
                          backgroundColor: AppColors.redLighterBackgroundColor,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.redColor),
                          onTap: () async {},
                        ),
                      ),
                      10.w,
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          title: t.trackers.medicines.finish,
                          type: CustomButtonType.outline,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          maxLines: 1,
                          textStyle: textTheme.bodyMedium!
                              .copyWith(color: AppColors.primaryColor),
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return EditMedicineDialog(
                                    medicineName: 'Panadol',
                                    dateAndTime: DateTime.now()
                                        .toString(), //widget.store.formattedTime,

                                    onPressFinishMedicine: () async {
                                      await widget.store.pickTime(context);
                                    },
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
            16.h,
            Expanded(
              child: CustomButton(
                title: t.trackers.save,
                textStyle: textTheme.bodyMedium!
                    .copyWith(color: AppColors.primaryColor),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                onTap: () async {
                  final model = DrugModel(
                    child_id: 'ad35f5d5-9911-4c12-bcda-9735b1946c8f',
                    data_start: dateStartController.text,
                    name_drug: nameDrugValue,
                    dose: doseValue,
                    notes: commentValue,
                    reminder: widget.store.formattedTime,
                    is_end: false,
                  );
                  widget.medicineStore.postData(model: model);
                },
                icon: AppIcons.pillsFill,
                iconSize: 28,
                iconColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
