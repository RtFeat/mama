import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

enum AddVaccineType { fromList, newVac }

enum EditVaccineType { add, edit }

class AddVaccine extends StatelessWidget {
  const AddVaccine({
    super.key,
    required this.data,
    required this.store,
  });

  final VaccinesStore? store;
  final EntityVaccinationMain? data;

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => AddVaccineViewStore(
            picker: context.read<Dependencies>().imagePicker,
            restClient: context.read<Dependencies>().restClient),
        builder: (context, child) {
          return _Body(
            model: data,
            store: store,
            addVaccineViewStore: context.watch(),
          );
        });
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.model,
    required this.store,
    required this.addVaccineViewStore,
  });

  final VaccinesStore? store;
  final AddVaccineViewStore addVaccineViewStore;
  final EntityVaccinationMain? model;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  void initState() {
    widget.addVaccineViewStore.init(widget.model);
    super.initState();
  }

  @override
  void dispose() {
    widget.addVaccineViewStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    return Observer(builder: (context) {
      final bool isAdd = widget.addVaccineViewStore.isAdd;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: !isAdd
              ? t.trackers.vaccines.addFromListVacAppBarTitle
              : t.trackers.vaccines.addNewVacAppBarTitle,
          appBarColor: AppColors.e8ddf9,
          padding: const EdgeInsets.only(right: 8),
          titleTextStyle: textTheme.headlineSmall!
              .copyWith(fontSize: 17, color: AppColors.blueDark),
        ),
        backgroundColor: AppColors.primaryColorBright,
        bottomNavigationBar: SafeArea(
            child: VaccineSaveButton(
                isEdit: (widget.model?.mark?.isEmpty ?? false),
                isAdd: isAdd,
                store: widget.addVaccineViewStore,
                vaccinesStore: widget.store)),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            isAdd
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.model?.name != null)
                        AutoSizeText(
                          widget.model?.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 24,
                              ),
                        ),
                      10.h,
                      AutoSizeText(
                        '${t.trackers.vaccines.recommendedAge} ${widget.model?.age}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(letterSpacing: -0.5),
                      ),
                      10.h,
                    ],
                  ),
            widget.addVaccineViewStore.image != null ||
                    (widget.addVaccineViewStore.imageUrl != null &&
                        widget.addVaccineViewStore.imageUrl!.isNotEmpty)
                ? GestureDetector(
                    onTap: widget.addVaccineViewStore.pickImage,
                    child: PhotoWidget(
                      height: 200,
                      borderRadius: BorderRadius.circular(16),
                      photoUrl: widget.addVaccineViewStore.imageUrl,
                      photoPath: widget.addVaccineViewStore.image?.path,
                    ),
                  )
                : SelectPhotoWidget(
                    onTap: widget.addVaccineViewStore.pickImage,
                  ),
            20.h,
            BodyGroup(
              formGroup: widget.addVaccineViewStore.formGroup,
              items: [
                !isAdd
                    ? const SizedBox.shrink()
                    : BodyItemWidget(
                        item: InputItem(
                          controlName: 'vaccine',
                          inputHint: t.trackers.vaccines.addNewVacField1Title,
                          hintText: t.trackers.vaccines.addNewVacField1Hint,
                          inputHintStyle: textTheme.bodySmall!
                              .copyWith(letterSpacing: -0.5),
                          titleStyle: textTheme.bodySmall!
                              .copyWith(color: AppColors.blackColor),
                          maxLines: 1,
                          onChanged: (value) {
                            // nameVaccine = value;
                            // widget.widget.store.updateData();
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
                    // controller: dateStartController,
                    readOnly: true,
                    onTap: (value) async {
                      widget.addVaccineViewStore.selectDate(context);
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
                    inputHint: t.trackers.vaccines.addNewVacField3Title,
                    hintText: t.trackers.vaccines.addNewVacField3Hint,
                    inputHintStyle:
                        textTheme.bodySmall!.copyWith(letterSpacing: -0.5),
                    titleStyle: textTheme.bodySmall!
                        .copyWith(color: AppColors.blackColor),
                    maxLines: 1,
                    onChanged: (value) {
                      // clinicValue = value;
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
                      // commentValue = value;
                    },
                  ),
                ),
              ],
            ),
            16.h,
          ],
        ),
      );
    });
  }
}
