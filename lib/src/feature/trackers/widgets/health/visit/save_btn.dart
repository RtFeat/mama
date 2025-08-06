import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class VisitSaveButton extends StatelessWidget {
  final AddDocVisitType type;
  final AddDoctorVisitViewStore store;
  final DoctorVisitsStore? doctorVisitsStore;
  const VisitSaveButton(
      {super.key,
      required this.type,
      required this.store,
      required this.doctorVisitsStore});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final UserStore userStore = context.watch();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          type == AddDocVisitType.add
              ? const SizedBox.shrink()
              : Expanded(
                  flex: 1,
                  child: CustomButton(
                    height: 48,
                    title: t.trackers.doctor.addNewVisitButtonDelete,
                    backgroundColor: AppColors.redLighterBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    textStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600, color: AppColors.redColor),
                    onTap: () {
                      store.delete().then((v) {
                        doctorVisitsStore?.listData
                            .removeWhere((e) => e.id == store.model!.id);
                        store.model = null;
                        if (context.mounted) context.pop();
                      });
                    },
                  ),
                ),
          type == AddDocVisitType.add ? const SizedBox.shrink() : 10.w,
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
              // onTap:
              //     store.isDoctorValid && widget.store.isDataStartValid ||
              //             widget.store.image != null
              //         ? () async {
              //             final model = DoctorVisitModel(
              //               child_id: 'ad35f5d5-9911-4c12-bcda-9735b1946c8f',
              //               data_start: dateStartController.text,
              //               // photo: nameDrugValue,
              //               clinic: clinicValue,
              //               notes: commentValue,
              //             );
              //             widget.doctorVisitStore.postData(model: model);
              //           }
              //         : null,

              onTap: () {
                store.save(userStore.selectedChild!.id!).then((value) {
                  doctorVisitsStore?.listData.add(store.model!);
                  if (context.mounted) context.pop();
                });
              },
              icon: AppIcons.stethoscope,
            ),
          ),
        ],
      ),
    );
  }
}
