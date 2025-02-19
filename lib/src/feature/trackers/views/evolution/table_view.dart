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
  List<bool> isSelectedWeight = [true, false];
  List<bool> isSelectedHeight = [true, false];

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
                    height: 30,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    title: t.trackers.pdf.title,
                    onTap: () {},
                    icon: AppIcons.arrowDownToLineCompact,
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
                  //!!! swith vertical переделать выравнивание по таблице
                  VericalToogleCustom(
                    isSelected: isSelectedWeight,
                    measure: UnitMeasures.weight,
                    onChange: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelectedWeight.length; i++) {
                          isSelectedWeight[i] = i == index;
                        }
                      });
                    },
                  ),

                  const SizedBox(width: 10),
                  VericalToogleCustom(
                    isSelected: isSelectedHeight,
                    measure: UnitMeasures.height,
                    onChange: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelectedHeight.length; i++) {
                          isSelectedHeight[i] = i == index;
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
            // Таблица бөлүгү (скролл менен кошо)
            Column(
              children: List.generate(
                5,
                (index) {
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

  Widget _buildIndicator({
    required String label,
    required Color? color,
    required Color textColor,
  }) {
    return Container(
      width: 100,
      height: 40,
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
