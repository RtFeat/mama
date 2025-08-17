import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart' hide LocaleSettings;

class VaccineSaveButton extends StatelessWidget {
  final bool isAdd;
  final bool isEdit;
  final AddVaccineViewStore store;
  final VaccinesStore? vaccinesStore;
  const VaccineSaveButton(
      {super.key,
      required this.isAdd,
      required this.store,
      required this.isEdit,
      required this.vaccinesStore});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final UserStore userStore = context.watch();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (!isAdd) ...[
            Expanded(
              flex: 1,
              child: CustomButton(
                height: 48,
                title: t.chat.delete,
                backgroundColor: AppColors.redLighterBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                textStyle: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.redColor),
                onTap: () {
                  store.delete().then((v) {
                    vaccinesStore?.listData
                        .removeWhere((e) => e.id == store.model!.id);
                    store.model = null;
                    if (context.mounted) context.pop();
                  });
                },
              ),
            ),
            10.w
          ],
          // !isAdd ? const SizedBox.shrink() : 10.w,
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
              title: t.profile.save,
              maxLines: 1,
              // onTap:
              //     store.isDoctorValid && widget.store.isDataStartValid ||
              //             widget.store.image != null
              //         ? () async {
              //             final model = DoctorVaccineModel(
              //               child_id: 'ad35f5d5-9911-4c12-bcda-9735b1946c8f',
              //               data_start: dateStartController.text,
              //               // photo: nameDrugValue,
              //               clinic: clinicValue,
              //               notes: commentValue,
              //             );
              //             widget.doctorVaccineStore.postData(model: model);
              //           }
              //         : null,

              onTap: () {
                if (isAdd) {
                  store.add(userStore.selectedChild!.id!).then((value) {
                    vaccinesStore?.listData.add(EntityVaccinationMain(
                      id: value,
                      mark: DateFormat(
                        'd MMMM y',
                        LocaleSettings.currentLocale.flutterLocale
                            .toLanguageTag(),
                      ).format(store.selectedDate),
                      markDescription:
                          userStore.selectedChild!.formattedDifference,
                      name: store.vaccine?.value,
                    ));
                    if (context.mounted) context.pop();
                  });
                } else {
                  store.update().then((v) {
                    final EntityVaccinationMain? vaccine = vaccinesStore
                        ?.listData
                        .firstWhere((e) => e.id == store.model!.id);
                    vaccine?.setMark(DateFormat(
                      'd MMMM y',
                      LocaleSettings.currentLocale.flutterLocale
                          .toLanguageTag(),
                    ).format(store.selectedDate));
                    vaccine?.setMarkDescription(
                        userStore.selectedChild!.formattedDifference);

                    if (context.mounted) context.pop();
                  });
                }
              },
              icon: AppIcons.stethoscope,
            ),
          ),
        ],
      ),
    );
  }
}
