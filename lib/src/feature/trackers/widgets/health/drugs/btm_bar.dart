import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class DrugsBottomBarWidget extends StatelessWidget {
  final bool isAdd;
  final DrugsStore? store;
  const DrugsBottomBarWidget({super.key, this.isAdd = true, this.store});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    final UserStore userStore = context.watch<UserStore>();
    final AddDrugsViewStore addDrugsViewStore =
        context.watch<AddDrugsViewStore>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Observer(builder: (context) {
        final bool hasData = addDrugsViewStore.model != null && addDrugsViewStore.model!.id != null;
        final bool isEnd = addDrugsViewStore.model?.isEnd ?? false;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasData) ...[
              Row(
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
                      onTap: () async {
                        addDrugsViewStore.delete().then((v) {
                          store?.listData.removeWhere(
                              (e) => e.id == addDrugsViewStore.model!.id);
                          if (context.mounted) context.pop();
                          addDrugsViewStore.model = null;
                        });
                      },
                    ),
                  ),
                  10.w,
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      title: isEnd
                          ? t.trackers.medicines.resume
                          : t.trackers.medicines.finish,
                      type: CustomButtonType.outline,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      maxLines: 1,
                      textStyle: textTheme.bodyMedium!
                          .copyWith(color: AppColors.primaryColor),
                      onTap: () async {
                        if (!isEnd) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return EditMedicineDialog(
                                  medicineName:
                                      addDrugsViewStore.model?.name ?? '',
                                  dateAndTime: DateTime.now()
                                      .toString(), //widget.store.formattedTime,

                                  onPressFinishMedicine: (dateTime) async {
                                    addDrugsViewStore
                                        .update(dataEnd: dateTime)
                                        .then((v) {
                                      final EntityMainDrug? model = store
                                          ?.listData
                                          .firstWhereOrNull((e) =>
                                              e.id ==
                                              addDrugsViewStore.model!.id);
                                      model?.toggleIsEnd();
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                );
                              }).then((v) {
                            if (context.mounted) context.pop();
                          });
                        } else {
                          addDrugsViewStore.update().then((v) {
                            final EntityMainDrug? model = store?.listData
                                .firstWhereOrNull(
                                    (e) => e.id == addDrugsViewStore.model!.id);
                            model?.toggleIsEnd();
                            if (context.mounted) context.pop();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              16.h,
            ],
            CustomButton(
              isSmall: false,
              title: t.trackers.save,
              textStyle:
                  textTheme.bodyMedium!.copyWith(color: AppColors.primaryColor),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              onTap: addDrugsViewStore.isSaving ? null : () async {
                if (!hasData) {
                  final childId = userStore.selectedChild?.id;
                  if (childId != null) {
                    logger.info('Начинаем добавление записи с childId: $childId, store: ${store != null ? "не null" : "null"}');
                    addDrugsViewStore
                        .add(childId, store)
                        .then((v) {
                      if (context.mounted) context.pop();
                    });
                  } else {
                    logger.error('childId равен null!');
                  }
                } else {
                  addDrugsViewStore.update().then((v) {
                    // Обновляем модель с новыми данными
                    if (addDrugsViewStore.model != null && store != null) {
                      final index = store?.listData.indexWhere((e) => e.id == addDrugsViewStore.model!.id);
                      if (index != null && index >= 0) {
                        // Создаем обновленную модель с новыми данными
                        final updatedModel = EntityMainDrug(
                          id: addDrugsViewStore.model!.id,
                          name: addDrugsViewStore.name?.value,
                          dose: addDrugsViewStore.dose?.value,
                          notes: addDrugsViewStore.comment?.value,
                          imageId: addDrugsViewStore.model!.imageId,
                          imagePath: addDrugsViewStore.image?.path,
                          reminder: addDrugsViewStore.model!.reminder,
                          reminderAfter: addDrugsViewStore.model!.reminderAfter,
                          dataStart: addDrugsViewStore.selectedDate.toIso8601String(),
                        );
                        store?.listData[index] = updatedModel;
                      }
                    }
                    if (context.mounted) context.pop();
                  });
                }
              },
              icon: AppIcons.pillsFill,
              iconSize: 28,
              iconColor: AppColors.primaryColor,
            ),
          ],
        );
      }),
    );
  }
}
