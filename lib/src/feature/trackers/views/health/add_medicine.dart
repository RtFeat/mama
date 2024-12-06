import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({
    super.key,
    required this.store,
    this.titlesStyle,
  });

  final DrugViewStore store;
  final TextStyle? titlesStyle;

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: t.trackers.medicines.add,
      ),
      backgroundColor: AppColors.primaryColorBright,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Observer(builder: (context) {
              return AddPhoto(
                onTap: () async {
                  await widget.store.pickImage();
                },
                image: widget.store.image,
              );
            }),
            20.h,
            BodyGroup(
              formGroup: widget.store.formGroup,
              title: t.profile.accountTitle,
              items: [
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'nameDrug',
                    inputHint: t.trackers.name.title,
                    hintText: t.trackers.name.subTitle,
                    titleStyle: textTheme.headlineSmall,
                    maxLines: 1,
                    onChanged: (value) {
                      // userStore.account.setIsChanged(true);
                      // widget.store.updateData();
                    },
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'dataStart',
                    inputHint: t.trackers.dateStart.title,
                    hintText: t.trackers.dateStart.subTitle,
                    titleStyle: widget.titlesStyle!.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    controller: dateStartController,
                    readOnly: true,
                    onTap: (value) async {
                      await widget.store.selectDateTime(context);
                      dateStartController.text = widget.store.formattedDateTime;
                    },
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'dose',
                    inputHint: t.trackers.dose.title,
                    hintText: t.trackers.dose.subTitle,
                    titleStyle: widget.titlesStyle!.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    onChanged: (value) {},
                  ),
                ),
                BodyItemWidget(
                  item: InputItem(
                    controlName: 'comment',
                    inputHint: t.trackers.comment.title,
                    hintText: t.trackers.comment.subTitle,
                    titleStyle: widget.titlesStyle!.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    onChanged: (value) {},
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
                      style: AppTextStyles.f17w400
                          .copyWith(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 8),
                    Observer(builder: (context) {
                      return Row(
                        children: [
                          Text(
                            widget.store.formattedTime,
                            style: AppTextStyles.f17w400
                                .copyWith(color: AppColors.primaryColor),
                          ),
                          widget.store.formattedTime == ''
                              ? const SizedBox()
                              : const SizedBox(width: 16),
                          CustomButton(
                            title: t.trackers.add.title,
                            textStyle: AppTextStyles.f17w400
                                .copyWith(color: AppColors.primaryColor),
                            icon: IconModel(
                              iconPath: Assets.icons.icClock,
                              color: AppColors.primaryColor,
                            ),
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
            16.h,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: t.trackers.save,
                    textStyle: AppTextStyles.f17w400
                        .copyWith(color: AppColors.primaryColor),
                    onTap: () {},
                    icon: IconModel(
                      iconPath: Assets.icons.icPillsFilled,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
