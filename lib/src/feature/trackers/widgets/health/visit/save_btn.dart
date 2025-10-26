import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
            child: Observer(
              builder: (_) => CustomButton(
                height: 48,
                width: double.infinity,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                title: t.trackers.doctor.addNewVisitButtonSave,
                maxLines: 1,
                onTap: store.isSaving ? null : () async {
                  await store.save(userStore.selectedChild!.id!);
                  
                  if (type == AddDocVisitType.add) {
                    // После добавления новой записи обновляем список с сервера, чтобы получить корректный ID
                    await doctorVisitsStore?.refreshForChild(userStore.selectedChild!.id!);
                    
                    // Находим только что созданную запись в обновленном списке и обновляем локальную модель
                    // Используем комбинацию полей для поиска (doctor + date), так как это уникальная комбинация
                    final visitsStore = doctorVisitsStore;
                    if (visitsStore != null) {
                      try {
                        final savedModel = visitsStore.listData.firstWhere(
                          (e) => e.doctor == store.doctor?.value && 
                                e.date?.day == store.selectedDate.day &&
                                e.date?.month == store.selectedDate.month &&
                                e.date?.year == store.selectedDate.year,
                        );
                        
                        // Обновляем модель с ID с сервера
                        if (savedModel.id != null) {
                          store.model = savedModel;
                        }
                      } catch (e) {
                        // Если запись не найдена, ничего не делаем
                        logger.info('Запись не найдена в обновленном списке: $e', runtimeType: runtimeType);
                      }
                    }
                  } else {
                    // При редактировании обновляем существующую запись
                    final index = doctorVisitsStore?.listData.indexWhere((e) => e.id == store.model!.id);
                    if (index != null && index >= 0) {
                      // Создаем обновленную модель с новыми данными
                      final updatedModel = EntityMainDoctor(
                        id: store.model!.id,
                        doctor: store.doctor?.value,
                        date: store.selectedDate,
                        clinic: store.clinic?.value,
                        notes: store.comment?.value,
                        photos: store.imagesUrls?.toList() ?? [],
                        isLocal: false,
                      );
                      doctorVisitsStore?.listData[index] = updatedModel;
                    }
                  }
                  if (context.mounted) context.pop();
                },
                icon: AppIcons.stethoscope,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
