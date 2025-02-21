import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum AddDocVisitType { add, edit }

class AddDocVisit extends StatefulWidget {
  const AddDocVisit({
    super.key,
    required this.store,
    this.titlesStyle,
    required this.doctorVisitStore,
    required this.type,
  });

  final DoctorVisitViewStore store;
  final DoctorVisitStore doctorVisitStore;
  final TextStyle? titlesStyle;
  final AddDocVisitType type;

  @override
  State<AddDocVisit> createState() => _AddDocVisitState();
}

class _AddDocVisitState extends State<AddDocVisit> {
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
    final controller = PageController();

    String? nameDoctor = '';
    String? clinicValue = '';
    String? commentValue = '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: t.trackers.doctor.addNewVisitTitle,
        appBarColor: AppColors.e8ddf9,
        padding: const EdgeInsets.only(right: 8),
        titleTextStyle: textTheme.headlineSmall!
            .copyWith(fontSize: 17, color: AppColors.blueDark),
      ),
      backgroundColor: AppColors.primaryColorBright,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            ListView(
              children: [
                Observer(builder: (context) {
                  return widget.store.image == null
                      ? DashedPhotoProfile(
                          backgroundColor: AppColors.primaryColorBright,
                          onIconTap: () async {
                            await widget.store.pickImage();
                          },
                          height: 200,
                          iconHeight: 26,
                          text: t.trackers.addPhoto,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32),
                          ),
                        )
                      : Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: PageView.builder(
                                    controller: controller,
                                    // itemCount: pages.length,
                                    itemBuilder: (_, index) {
                                      return const ProfilePhoto(
                                        isShowIcon: false,
                                        height: 358,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                3.h,
                                SmoothPageIndicator(
                                  controller: controller,
                                  count: 3, // TODO выставить по кол-ву фото
                                  effect: CustomizableEffect(
                                    activeDotDecoration: DotDecoration(
                                      width: 24,
                                      height: 8,
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    dotDecoration: DotDecoration(
                                      width: 8,
                                      height: 8,
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(16),
                                      verticalOffset: 0,
                                    ),
                                    spacing: 4.0,
                                  ),
                                ),
                              ],
                            ),
                            DashedPhotoProfile(
                              backgroundColor: AppColors.primaryColorBright,
                              onIconTap: () async {
                                await widget.store.pickImage();
                              },
                              height: 200,
                              width: 48,
                              iconHeight: 26,
                              needText: false,
                              text: t.trackers.addPhoto,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                              radius: 16,
                            )
                          ],
                        );
                }),
                20.h,
                BodyGroup(
                  formGroup: widget.store.formGroup,
                  items: [
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'doctor',
                        inputHint: t.trackers.doctor.addNewVisitField1Title,
                        hintText: t.trackers.doctor.addNewVisitField1Hint,
                        inputHintStyle:
                            textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                        titleStyle: textTheme.bodySmall!
                            .copyWith(color: AppColors.blackColor),
                        maxLines: 1,
                        onChanged: (value) {
                          nameDoctor = value;
                          widget.store.updateData();
                        },
                      ),
                    ),
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'dataStart',
                        inputHint: t.trackers.doctor.addNewVisitField2Title,
                        hintText: t.trackers.doctor.addNewVisitField2Hint,
                        inputHintStyle:
                            textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                        titleStyle: textTheme.bodySmall!
                            .copyWith(color: AppColors.blackColor),
                        maxLines: 1,
                        controller: dateStartController,
                        readOnly: true,
                        onTap: (value) async {
                          dateStartController.text =
                              widget.store.formattedDateTime;
                          widget.store.formattedDateTime;
                          widget.store.updateData();
                        },
                      ),
                    ),
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'clinic',
                        inputHint: t.trackers.doctor.addNewVisitField3Title,
                        hintText: t.trackers.doctor.addNewVisitField3Hint,
                        inputHintStyle:
                            textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                        titleStyle: textTheme.bodySmall!
                            .copyWith(color: AppColors.blackColor),
                        maxLines: 1,
                        onChanged: (value) {
                          clinicValue = value;
                        },
                      ),
                    ),
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'comment',
                        inputHint: t.trackers.doctor.addNewVisitField4Title,
                        hintText: t.trackers.doctor.addNewVisitField4Hint,
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
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    widget.type == AddDocVisitType.add
                        ? const SizedBox.shrink()
                        : Expanded(
                            flex: 1,
                            child: CustomButton(
                              height: 48,
                              title: t.trackers.doctor.addNewVisitButtonDelete,
                              backgroundColor:
                                  AppColors.redLighterBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              textStyle: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.redColor),
                              onTap: () {}, // TODO удалить визит
                            ),
                          ),
                    widget.type == AddDocVisitType.add
                        ? const SizedBox.shrink()
                        : 10.w,
                    // Todo сделать кнопку неактивной если not valid
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        height: 48,
                        width: double.infinity,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        title: t.trackers.doctor.addNewVisitButtonSave,
                        maxLines: 1,
                        onTap: widget.store.isDoctorValid &&
                                    widget.store.isDataStartValid ||
                                widget.store.image != null
                            ? () async {
                                final model = DoctorVisitModel(
                                  child_id:
                                      'ad35f5d5-9911-4c12-bcda-9735b1946c8f',
                                  data_start: dateStartController.text,
                                  // photo: nameDrugValue,
                                  clinic: clinicValue,
                                  notes: commentValue,
                                );
                                widget.doctorVisitStore.postData(model: model);
                              }
                            : null,
                        icon: AppIcons.stethoscope,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
