import 'package:flutter/material.dart';
import 'package:mama/src/core/core.dart';
import 'package:mama/src/feature/services/knowledge/widgets/common_medic_card.dart';
import 'package:mama/src/feature/services/knowledge/widgets/common_service_info_screen_widgets.dart';
import 'package:mama/src/feature/services/utils/text_helper.dart';

class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        action: SizedBox(
          height: 46,
          width: MediaQuery.of(context).size.width * 0.4,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.lightPirple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.services.toSave.title,
                  style: TextStyle(
                    fontFamily: Assets.fonts.sFProTextMedium,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(Assets.images.save.path),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AppBody(
            builder: (windowWidth, windowSize) => ListView(
              padding: HorizontalSpacing.centered(windowWidth),
              children: [
                10.h,
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {},
                  child: const MedicCard(),
                ),
                10.h,
                Text(
                  t.services.childDevelopment.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  height: 246,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(Assets.images.imgMomOne4x.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childDevDescription,
                ),
                10.h,
                const Text(
                  'Физическое развитие ребенка в 6 месяцев',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childPhysDescription,
                ),
                10.h,
                const Text(
                  'Что умеет ребенок в 6 месяцев',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                const Text(
                  'Зрение',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childVision,
                ),
                10.h,
                const Text(
                  'Слух',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childVision,
                ),
                10.h,
                const Text(
                  'Речь',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childSpeech,
                ),
                10.h,
                const Text(
                  'Моторика',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childMotoric,
                ),
                10.h,
                const Text(
                  'Эмоции',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childEmotion,
                ),
                10.h,
                const Text(
                  'Игра',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childGame,
                ),
                10.h,
                Container(
                  height: 144,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(Assets.images.baby.path),
                    ),
                  ),
                ),
                10.h,
                const Text(
                  'Режим дня в 6 месяцев',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childRegimen,
                ),
                20.h,
                const Text(
                  'Режим сна',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.h,
                SizedBox(
                  child: TextHelper.childSleep,
                ),
                10.h,
                const CommonHorizontalWidget(
                  mainTittle: 'Развитие ребенка в 6 месяцев',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
