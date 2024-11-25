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
            AddSomethingTextField(
              hintText: t.trackers.name.title,
              title: t.trackers.name.subTitle,
            ),
            const SizedBox(height: 16),
            AddSomethingTextField(
              hintText: t.trackers.dateStart.title,
              title: t.trackers.dateStart.subTitle,
            ),
            const SizedBox(height: 16),
            AddSomethingTextField(
              hintText: t.trackers.dose.title,
              title: t.trackers.dose.subTitle,
            ),
            const SizedBox(height: 16),
            AddSomethingTextField(
              hintText: t.trackers.comment.title,
              title: t.trackers.comment.subTitle,
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
                      t.trackers.dailyreminders,
                      style: AppTextStyles.f17w400
                          .copyWith(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 8),
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
