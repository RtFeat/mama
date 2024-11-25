import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class AddMedicine extends StatelessWidget {
  const AddMedicine({super.key});

  @override
  Widget build(BuildContext context) {
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
            const AddPhoto(),
            const SizedBox(height: 16),
            const AddSomethingTextField(
              hintText: 'Название',
              title: 'Нажмите, чтобы ввести название лекарства',
            ),
            const SizedBox(height: 16),
            const AddSomethingTextField(
              hintText: 'Дата начала приема',
              title: 'Нажмите, чтобы указать дату начала приема',
            ),
            const SizedBox(height: 16),
            const AddSomethingTextField(
              hintText: 'Доза',
              title:
                  'Нажмите, чтобы указать дозу. Она будет сразу видна на экране лекарств',
            ),
            const SizedBox(height: 16),
            const AddSomethingTextField(
              hintText: 'Комментарий',
              title: 'Нажмите, чтобы добавить комментарий',
            ),
            const SizedBox(height: 16),
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
                      'Ежедневные напоминания',
                      style: AppTextStyles.f17w400
                          .copyWith(color: AppColors.blackColor),
                    ),
                    CustomButton(
                      title: t.trackers.add.title,
                      textStyle: AppTextStyles.f17w400
                          .copyWith(color: AppColors.primaryColor),
                      onTap: () {},
                      icon: IconModel(
                        iconPath: Assets.icons.icClock,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
