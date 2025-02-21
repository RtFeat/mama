import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

enum AddVaccineType { fromList, newVac }

enum EditVaccineType { add, edit }

class AddVaccine extends StatefulWidget {
  const AddVaccine({
    super.key,
    required this.store,
    this.titlesStyle,
    required this.vaccinesStore,
    required this.type,
    this.nameVaccine,
    this.recomendedAge,
    required this.editType,
  });

  final VaccinesViewStore store;
  final String? nameVaccine;
  final String? recomendedAge;
  final VaccinesStore vaccinesStore;
  final TextStyle? titlesStyle;
  final AddVaccineType type;
  final EditVaccineType editType;

  @override
  State<AddVaccine> createState() => _AddVaccineState();
}

class _AddVaccineState extends State<AddVaccine> {
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

    String? nameVaccine = '';
    String? clinicValue = '';
    String? commentValue = '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: widget.type == AddVaccineType.fromList
            ? t.trackers.vaccines.addFromListVacAppBarTitle
            : t.trackers.vaccines.addNewVacAppBarTitle,
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
                widget.type == AddVaccineType.newVac
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          AutoSizeText(
                            widget.nameVaccine!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontSize: 24,
                                ),
                          ),
                          10.h,
                          AutoSizeText(
                            '${t.trackers.vaccines.recommendedAge} ${widget.recomendedAge!}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(letterSpacing: -0.5),
                          ),
                          10.h,
                        ],
                      ),
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
                            SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width - 80,
                              child: const ProfilePhoto(
                                isShowIcon: false,
                                height: 358,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                              ),
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
                    widget.type == AddVaccineType.fromList
                        ? const SizedBox.shrink()
                        : BodyItemWidget(
                            item: InputItem(
                              controlName: 'vaccine',
                              inputHint:
                                  t.trackers.vaccines.addNewVacField1Title,
                              hintText: t.trackers.vaccines.addNewVacField1Hint,
                              inputHintStyle: textTheme.bodySmall!.copyWith(
                                letterSpacing: -0.5,
                                fontSize: 14,
                              ),
                              titleStyle: textTheme.bodySmall!
                                  .copyWith(color: AppColors.blackColor),
                              maxLines: 1,
                              onChanged: (value) {
                                nameVaccine = value;
                                widget.store.updateData();
                              },
                            ),
                          ),
                    BodyItemWidget(
                      item: InputItem(
                        controlName: 'dataStart',
                        inputHint: t.trackers.vaccines.addNewVacField2Title,
                        hintText: t.trackers.vaccines.addNewVacField2Hint,
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
                        inputHint: t.trackers.vaccines.addNewVacField3Title,
                        hintText: t.trackers.vaccines.addNewVacField3Hint,
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
                        inputHint: t.trackers.vaccines.addNewVacField4Title,
                        hintText: t.trackers.vaccines.addNewVacField4Hint,
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
                    widget.editType == EditVaccineType.add
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
                              onTap: () {}, // TODO удалить прививку
                            ),
                          ),
                    widget.editType == EditVaccineType.add
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
                        title: t.trackers.vaccines.addNewVacButtonSave,
                        maxLines: 1,
                        onTap:
                            // widget.store.isDoctorValid &&
                            //             widget.store.isDataStartValid ||
                            //         widget.store.image != null
                            //     ? () async {
                            //         final model = DoctorVisitModel(
                            //           child_id:
                            //               'ad35f5d5-9911-4c12-bcda-9735b1946c8f',
                            //           data_start: dateStartController.text,
                            //           // photo: nameDrugValue,
                            //           clinic: clinicValue,
                            //           notes: commentValue,
                            //         );
                            //         widget.vaccinesStore.postData(model: model);
                            //       }
                            //     : null,
                            () {},
                        icon: AppIcons.syringeFill,
                        iconSize: 28,
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
