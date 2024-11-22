import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:mama/src/feature/trackers/widgets/evolution_category.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key, required this.trackerType});

  final EvolutionCategory trackerType;

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SwitchContainer(
                    title1: t.trackers.news.title,
                    title2: t.trackers.old.title,
                  ),
                  CustomButton(
                    title: t.trackers.pdf.title,
                    onTap: () {},
                    icon: IconModel(
                      iconPath: Assets.icons.icArrowDownFilled,
                    ),
                    // type: CustomButtonType.outline,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Text(
                        'Обратите внимание',
                        style: AppTextStyles.f10w700
                            .copyWith(color: AppColors.greyBrighterColor),
                      ),
                      const SizedBox(height: 10),

                      // Индикаторы
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildIndicator(
                            label: 'Граница\nнормы',
                            color: AppColors.greenLighterBackgroundColor,
                            textColor: AppColors.greenTextColor,
                          ),
                          const SizedBox(width: 10),
                          _buildIndicator(
                            label: 'Вне нормы',
                            color: AppColors.yellowBackgroundColor,
                            textColor: AppColors.orangeTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(width: 10),
                  //!!! swith vertical
                  CustomToggleButton(
                    isSelected: isSelected,
                    onToggle: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 10),

                  CustomToggleButton(
                    isSelected: isSelected,
                    onToggle: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RowStroriesData(
                data: t.trackers.date.title,
                week: t.trackers.weeks.title,
                weight: t.trackers.weight.title,
                growth: t.trackers.growth.title,
                head: t.trackers.head.title,
                style: AppTextStyles.f10w700.copyWith(
                  color: AppColors.greyBrighterColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RowStroriesData(
                      data: '01 сентября',
                      week: '17',
                      weight: '6,25',
                      growth: '6,25',
                      head: '6,25',
                      style: AppTextStyles.f17w400,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Виджет для индикаторов состояния
  Widget _buildIndicator({
    required String label,
    required Color? color,
    required Color textColor,
  }) {
    return Container(
      width: 100,
      height: 40,
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.f10w700.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomToggleButton extends StatelessWidget {
  final List<bool> isSelected;
  final void Function(int) onToggle;

  const CustomToggleButton({
    super.key,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.purpleLighterBackgroundColor,
      ),
      child: ToggleButtons(
        constraints: const BoxConstraints(
          minHeight: 30,
          minWidth: 60,
        ),
        direction: Axis.vertical,
        isSelected: isSelected,
        borderRadius: BorderRadius.circular(8),
        fillColor: AppColors.whiteColor,
        selectedColor: AppColors.whiteColor,
        color: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: onToggle,
        children: [
          Text(
            t.trackers.kg.title,
            style: TextStyle(
              color: isSelected[0]
                  ? AppColors.primaryColor
                  : AppColors.greyBrighterColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            t.trackers.g.title,
            style: TextStyle(
              color: isSelected[1]
                  ? AppColors.primaryColor
                  : AppColors.greyBrighterColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
