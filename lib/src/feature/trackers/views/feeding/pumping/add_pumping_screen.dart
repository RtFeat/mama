import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/add_pumping_input.dart';
import 'package:skit/skit.dart';

class AddPumpingScreen extends StatelessWidget {
  const AddPumpingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(t.feeding.pumping,
            style: textTheme.titleMedium
                ?.copyWith(color: const Color(0xFF163C63))),
      ),
      backgroundColor: const Color(0xFFE7F2FE),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            children: [
              const Spacer(),
              const AddPumpingInput(),
              35.h,
              DateSwitchContainer(
                //TODO настроить вывод даты и времени
                title1: t.trackers.now.title,
                title2: t.trackers.sixTeenThirtyTwo.title,
                title3: t.trackers.fourteensOfSeptember.title,
              ),
              30.h,
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 48,
                      width: double.infinity,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      type: CustomButtonType.outline,
                      // icon: IconModel(
                      //     color: AppColors.primaryColor,
                      //     iconPath: Assets.icons.icPencilFilled),

                      icon: AppIcons.pencil,
                      iconColor: AppColors.primaryColor,
                      title: t.feeding.note,
                      onTap: () {},
                    ),
                  ),
                  10.w,
                  Expanded(
                    child: CustomButton(
                      backgroundColor: AppColors.redLighterBackgroundColor,
                      height: 48,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      type: CustomButtonType.filled,
                      // icon: IconModel(iconPath: Assets.icons.icClose),
                      icon: AppIcons.xmark,
                      iconColor: AppColors.redColor,
                      title: t.feeding.cancel,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              10.h,
              CustomButton(
                backgroundColor: AppColors.greenLighterBackgroundColor,
                height: 48,
                width: double.infinity,
                title: t.feeding.confirm,
                textStyle: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.greenTextColor),
                onTap: () {},
              ),
              20.h,
            ],
          ),
        ),
      ),
    );
  }
}
