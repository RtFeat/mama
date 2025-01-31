import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';

class AddManuallyScreen extends StatelessWidget {
  const AddManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FE),
      appBar: CustomAppBar(
        height: 55,
        titleWidget: Text(t.feeding.addManually,
            style: textTheme.titleMedium
                ?.copyWith(color: const Color(0xFF163C63))),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.5,
            ),
            const ManuallyInputContainer(),
            30.h,
            Row(
              children: [
                Expanded(
                    child: DetailContainer(
                  title: t.feeding.start,
                  text: '16:35',
                  detail: t.feeding.change,
                  filled: true,
                  isEdited: true,
                )),
                10.w,
                Expanded(
                    child: DetailContainer(
                  title: t.feeding.end,
                  text: '16:35',
                  detail: t.feeding.timerStarted,
                  filled: true,
                  isEdited: true,
                )),
                10.w,
                Expanded(
                    child: DetailContainer(
                  title: t.feeding.total,
                  text: '0м 0с',
                  detail: '',
                  filled: false,
                  isEdited: true,
                )),
              ],
            ),
            30.h,
            CustomButton(
              height: 48,
              width: double.infinity,
              type: CustomButtonType.outline,
              // icon: IconModel(
              //     color: AppColors.primaryColor,
              //     iconPath: Assets.icons.icPencilFilled),
              icon: AppIcons.pencil,
              iconColor: AppColors.primaryColor,
              title: t.feeding.note,
              onTap: () {},
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
            35.h,
          ],
        ),
      ),
    );
  }
}
