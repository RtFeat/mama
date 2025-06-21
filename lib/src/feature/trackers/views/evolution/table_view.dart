import 'package:flutter/material.dart';
import 'package:mama/src/data.dart';
import 'package:provider/provider.dart';
import 'package:skit/skit.dart';

class TablePage extends StatelessWidget {
  const TablePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => EvolutionStore(
          faker: context.read<Dependencies>().faker,
          apiClient: context.read<Dependencies>().apiClient),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TableEvolutionHistory(
            store: context.watch(),
          ),
        ),
      ),
    );
  }
}

class TableEvolutionHistory extends StatefulWidget {
  final EvolutionStore store;

  const TableEvolutionHistory({
    super.key,
    required this.store,
  });

  @override
  State<TableEvolutionHistory> createState() => _TableEvolutionHistoryState();
}

class _TableEvolutionHistoryState extends State<TableEvolutionHistory> {
  @override
  void initState() {
    widget.store.loadPage();
    super.initState();
  }

  List<bool> isSelectedWeight = [true, false];
  List<bool> isSelectedHeight = [true, false];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                children: [
                  CustomToggleButton(
                      alignment: Alignment.topLeft,
                      items: [t.feeding.newS, t.feeding.old],
                      onTap:
                          (index) {}, // TODO переключение между новыми и старыми
                      btnWidth: 64,
                      btnHeight: 26),
                  Expanded(
                    child: Row(
                      children: [
                        const Spacer(),
                        CustomButton(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          icon: AppIcons.arrowDownToLineCompact,
                          title: t.trackers.pdf.title,
                          height: 26,
                          width: 70,
                          onTap: () {}, // TODO скачать pdf
                        )
                      ],
                    ),
                  )
                ],
              ),
              15.h,
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок
                  Text(
                    t.trackers.evolution.attention,
                    style: AppTextStyles.f10w700
                        .copyWith(color: AppColors.greyBrighterColor),
                  ),
                  10.h,

                  // Индикаторы
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildIndicator(
                        label: t.trackers.evolution.norm,
                        color: AppColors.greenLighterBackgroundColor,
                        textColor: AppColors.greenTextColor,
                      ),
                      10.w,
                      _buildIndicator(
                        label: t.trackers.evolution.anormal,
                        color: AppColors.yellowBackgroundColor,
                        textColor: AppColors.orangeTextColor,
                      ),
                    ],
                  ),
                  12.h,
                ],
              ),
              10.w,
              VericalToogleCustom(
                width: 50,
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
              10.w,
              VericalToogleCustom(
                width: 50,
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
              40.w,
            ],
          ),
        ),
        if (widget.store.listData.isNotEmpty)
          SliverToBoxAdapter(
            child: SkitTableWidget(
              store: widget.store,
            ),
          ),
// TODO виджет для добавления строк
      ],
    );
  }

  Widget _buildIndicator({
    required String label,
    required Color? color,
    required Color textColor,
  }) {
    return Container(
      width: 85,
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
